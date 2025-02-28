//
//  GoalListFeature+Action.swift
//  FeatureGoal
//
//  Created by Importants on 2/15/25.
//

import ComposableArchitecture
import Data
import Foundation

extension GoalListFeature {
    // MARK: ViewCycling
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            guard state.goalContents.isEmpty else { return .none }
            state.isLoading = true
            state.didFailToLoad = false
            return .send(.feature(.fetchGoals))
        }
    }
    // MARK: View
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .retryButtonTapped:
            state.isLoading = true
            state.didFailToLoad = false
            return .send(.feature(.fetchGoals))
        case .onLoadMore:
            guard state.pagingationState.hasMorePages else { return .none }
            return .send(.feature(.fetchGoals))
                .throttle(
                         id: PublisherID.throttle,
                         for: .milliseconds(500),
                         scheduler: DispatchQueue.main,
                         latest: true)
        case let .contentTapped(contentId):
            return .send(.delegate(.showGoalDetail(contentId)))
        }
    }
    // MARK: Feature
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .fetchGoals:
            state.isScrollFetching = true
            return .run { [currentPage = state.pagingationState.currentPage] send in
                do {
                    let response = try await goalClient.fetchGoals(page: currentPage)
                    await send(.feature(
                            .checkFetchGoalListResponse(
                                .success(
                                    response.goals,
                                    response.page?.hasNext ?? false
                                )
                            )))
                } catch is NetworkError {
                    await send(
                        .feature(.checkFetchGoalListResponse(.networkError))
                    )
                } catch {
                    await send(
                        .feature(.checkFetchGoalListResponse(.failed))
                    )
                }
            }
        case let .checkFetchGoalListResponse(result):
            switch result {
            case let .success(contents, hasNext):
                state.goalContents.append(contentsOf: contents)
                state.pagingationState.totalCount += contents.count
                state.pagingationState.currentPage += 1
                state.pagingationState.hasMorePages = hasNext
            case .networkError, .failed:
                if state.isLoading {
                    state.didFailToLoad = true
                }
            }
            state.isLoading = false
            state.isScrollFetching = false
            return .none
        }
    }

    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
