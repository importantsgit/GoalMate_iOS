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
            guard state.hasNextPage else { return .none }
            let page = state.currentPage
            state.isLoading = true
            return .run { send in
                do {
                    let response = try await goalClient.fetchGoals(
                        page: page
                    )
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
                            .fetchGoalListResponse(
                                .success((mappedContents, response.page?.hasNext ?? false))
                            )))
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    // MARK: View
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .onLoadMore:
            guard state.hasNextPage else { return .none }
            let page = state.currentPage
            state.isLoading = true
            return .run { send in
                do {
                    let response = try await goalClient.fetchGoals(page: page)
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
                            .fetchGoalListResponse(
                                .success((
                                    mappedContents,
                                    response.page?.hasNext ?? false
                                ))
                            )))
                } catch {
                    print(error.localizedDescription)
                }
            }
        default: return .none
        }
    }
    // MARK: Feature
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case let .fetchGoalListResponse(result):
            switch result {
            case let .success((contents, hasNext)):
                state.currentPage += 1
                state.hasNextPage = hasNext
                state.goalContents.append(contentsOf: contents)
            case let .failure(error):
                print(error.localizedDescription)
            }
            state.isLoading = false
            return .none
        }
    }
}
