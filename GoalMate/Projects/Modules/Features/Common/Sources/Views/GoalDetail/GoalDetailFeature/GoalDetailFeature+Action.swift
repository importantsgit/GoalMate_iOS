//
//  GoalDetailFeature+Action.swift
//  FeatureGoal
//
//  Created by Importants on 2/16/25.
//

import ComposableArchitecture
import Data
import Foundation

extension GoalDetailFeature {
    enum CancelID: Hashable {
        case initialLoad
    }
    // MARK: ViewCycling
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
            return .run { send in
                await send(
                    .feature(.checkLogin(try await authClient.checkLoginStatus()))
                )
            }
        }
    }
    // MARK: View
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .loginButtonTapped:
            return .send(.delegate(.showLogin))
        case .retryButtonTapped:
            state.didFailToLoad = false
            state.isLoading = true
            return .run { [contentId = state.contentId ] send in
                do {
                    let content = try await goalClient.fetchGoalDetail(goalId: contentId)
                    await send(.feature(
                        .checkFetchDetailResponse(.success(content))))
                } catch is NetworkError {
                    await send(.feature(
                        .checkFetchDetailResponse(.networkError))
                    )
                } catch {
                    await send(.feature(
                        .checkFetchDetailResponse(.failed))
                    )
                }
            }
        case .backButtonTapped:
            return .send(.delegate(.closeView))
        case .startButtonTapped:
            guard let content = state.content
            else { return .none }
            return
                .concatenate(
                    .cancel(id: CancelID.initialLoad),
                    .send(.delegate(.showPurchaseSheet(content)))
                )
        case .popupButtonTapped:
            state.isShowUnavailablePopup = false
            return .none
        }
    }
    // MARK: Feature
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case let .checkLogin(isLogin):
            state.isLogin = isLogin
            return .send(.feature(.fetchDetail))
        case .fetchDetail:
            return .run { [contentId = state.contentId ] send in
                    do {
                        let content = try await goalClient.fetchGoalDetail(goalId: contentId)
                        await send(.feature(
                            .checkFetchDetailResponse(.success(content))))
                    } catch is NetworkError {
                        await send(.feature(
                            .checkFetchDetailResponse(.networkError))
                        )
                    } catch {
                        await send(.feature(
                            .checkFetchDetailResponse(.failed))
                        )
                    }
                }
        case let .checkFetchDetailResponse(result):
            switch result {
            case let .success(detail):
                state.content = detail
                state.isLoading = false
            case .networkError, .failed:
                state.isLoading = true
                state.didFailToLoad = true
            }
            return .none
        case let .showToast(message):
            state.toastState = .display(message)
            return .none
        }
    }
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
