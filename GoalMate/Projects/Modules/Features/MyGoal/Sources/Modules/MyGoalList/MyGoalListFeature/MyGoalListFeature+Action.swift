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
            guard state.hasMorePages else { return .none }
            state.isLoading = true
            return .run { send in
                guard try await authClient.checkLoginStatus()
                else {
                    print("Login Failed")
                    await send(.feature(.loginFailed))
                    return
                }
                await send(.feature(.fetchMyGoals))
            }
        }
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .retryButtonTapped, .onLoadMore:
            guard state.hasMorePages else { return .none }
            state.isLoading = true
            return .send(.feature(.fetchMyGoals))
        case let .buttonTapped(type):
            switch type {
            case let .showGoalRestart(contentId):
                return .send(.delegate(.showGoalList))
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
            guard state.hasMorePages else {
                state.isLoading = false
                return .none
            }
            state.isScrollFetching = true
            return .run { [currentPage = state.currentPage] send in
                do {
                    let response = try await menteeClient.fetchMyGoals(currentPage)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let list: [MyGoalContent] = response.menteeGoals.map { goal in
                            .init(
                                id: goal.id,
                                title: goal.title,
                                progress: CGFloat((goal.totalCompletedCount ?? 0) /
                                                  (goal.totalTodoCount ?? 1)),
                                startDate: goal.startDate,
                                endDate: goal.endDate,
                                mainImageURL: goal.mainImage,
                                goalStatus: goal.menteeGoalStatus ?? .inProgress
                            )
                    }
                    await send(
                        .feature(
                            .checkFetchMyGoalResponse(.success(list, response.page?.hasNext ?? false))
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
                state.myGoalList += myGoals
                state.totalCount += myGoals.count
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
