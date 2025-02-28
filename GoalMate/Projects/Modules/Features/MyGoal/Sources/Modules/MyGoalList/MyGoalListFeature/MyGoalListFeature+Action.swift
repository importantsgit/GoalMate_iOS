//
//  MyGoalListFeature+Action.swift
//  FeatureMyGoal
//
//  Created by Importants on 2/19/25.
//

import ComposableArchitecture
import Data
import Foundation

extension MyGoalListFeature {
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                guard try await authClient.checkLoginStatus()
                else {
                    print("Login Failed")
                    await send(.feature(.loginFailed))
                    return
                }
                await send(.feature(.fetchMyGoals))
            }
        case .onDisappear:
            state.isLoading = true
            state.isLogin = true
            state.didFailToLoad = false
            state.myGoalList = []
            state.pagingationState = .init()
            return .none
        }
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .retryButtonTapped:
            state.didFailToLoad = false
            state.isLoading = true
            return .send(.feature(.fetchMyGoals))
        case .onLoadMore:
            guard state.pagingationState.hasMorePages,
                  state.isScrollFetching == false
            else { return .none }
            state.isScrollFetching = true
            return .send(.feature(.fetchMyGoals))
                .throttle(
                    id: PublisherID.throttle,
                    for: .milliseconds(500),
                    scheduler: DispatchQueue.main,
                    latest: true)
        case let .buttonTapped(type):
            switch type {
            case let .showGoalRestart(contentId):
                return .send(.delegate(.restartGoal(contentId)))
            case let .showGoalDetail(contentId):
                return .send(.delegate(.showMyGoalDetail(contentId)))
            case let .showGoalCompletion(contentId):
                return .send(.delegate(.showMyGoalCompletion(contentId)))
            }
        case .showMoreButtonTapped:
            return .send(.delegate(.showGoalList))
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .fetchMyGoals:
            return .run { [currentPage = state.pagingationState.currentPage] send in
                do {
                    let response = try await menteeClient.fetchMyGoals(currentPage)
                    let list = response.menteeGoals
                    await send(
                        .feature(
                            .checkFetchMyGoalResponse(
                                .success(list, response.page?.hasNext ?? false))
                        )
                    )
                } catch let error as NetworkError {
                    if case let .statusCodeError(code) = error,
                       code == 401 {
                        await send(.feature(.loginFailed))
                        return
                    }
                    await send(
                        .feature(.checkFetchMyGoalResponse(.networkError))
                    )
                } catch {
                    await send(
                        .feature(.checkFetchMyGoalResponse(.failed))
                    )
                }
            }
        case .loginFailed:
            state.isLogin = false
            state.isLoading = false
            return .none
        case let .checkFetchMyGoalResponse(result):
            switch result {
            case let .success(myGoals, hasNext):
                state.myGoalList.append(contentsOf: myGoals)
                state.pagingationState.totalCount += myGoals.count
                state.pagingationState.currentPage += 1
                state.pagingationState.hasMorePages = hasNext
            case .networkError:
                if state.isLoading {
                    state.didFailToLoad = true
                }
            case .failed:
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
