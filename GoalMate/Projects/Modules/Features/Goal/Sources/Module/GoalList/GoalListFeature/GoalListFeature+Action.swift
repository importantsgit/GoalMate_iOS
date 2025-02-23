//
//  GoalListFeature+Action.swift
//  FeatureGoal
//
//  Created by Importants on 2/15/25.
//

import ComposableArchitecture
import Data

extension GoalListFeature {
    // MARK: ViewCycling
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            guard state.hasMorePages else { return .none }
            state.isLoading = true
            return .send(.feature(.fetchGoals))
        }
    }
    // MARK: View
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .retryButtonTapped:
            return .send(.feature(.fetchGoals))
        case .onLoadMore:
            return .send(.feature(.fetchGoals))
        case let .contentTapped(contentId):
            return .send(.delegate(.showGoalDetail(contentId)))
        }
    }
    // MARK: Feature
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .fetchGoals:
            guard state.hasMorePages
            else {
                state.isLoading = false
                return .none
            }
            state.isScrollFetching = true
            return .run { [currentPage = state.currentPage] send in
                do {
                    let response = try await goalClient.fetchGoals(page: currentPage)
                    let mappedContents = await withTaskGroup(of: GoalContent.self) { group in
                        for goal in response.goals {
                            group.addTask {
                                // 각 Goal을 GoalContent로 변환
                                return GoalContent(
                                    id: goal.id,
                                    title: goal.title ?? "",
                                    discountPercentage: 30, // 임시 값
                                    originalPrice: 30000,   // 임시 값
                                    discountedPrice: 21000, // 임시 값
                                    maxOccupancy: goal.participantsLimit ?? 0,
                                    remainingCapacity: (goal.participantsLimit ?? 0) -
                                    (goal.currentParticipants ?? 0),
                                    currentParticipants: goal.currentParticipants ?? 0,
                                    imageURL: goal.mainImage ?? ""
                                )
                            }
                        }
                        var contents: [GoalContent] = []
                        for await content in group {
                            contents.append(content)
                        }
                        return contents
                    }
                    await send(.feature(
                            .checkFetchGoalListResponse(
                                .success(
                                    mappedContents,
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
                state.goalContents += contents
                state.totalCount += contents.count
                state.currentPage += 1
                state.hasMorePages = hasNext
            case .networkError:
                state.didFailToLoad = true
            case .failed:
                break
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
