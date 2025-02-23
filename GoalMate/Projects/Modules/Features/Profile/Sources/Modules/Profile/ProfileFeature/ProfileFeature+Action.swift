//
//  ProfileFeature+Action.swift
//  FeatureProfile
//
//  Created by Importants on 2/12/25.
//

import ComposableArchitecture
import Data
import Foundation
import Utils

extension ProfileFeature {
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
            return .run { send in
                await send(.feature(.checkLogin(
                    try await authClient.checkLoginStatus()
                )))
            }
        }
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .nicknameEditButtonTapped:
            return .send(
                .delegate(.showNicknameEdit(state.profile?.name ?? ""))
            )
        case .qnaButtonTapped:
            guard let url = URL(
                string: Environments.qnaURLString
            )
            else { return .none }
            return .run { [url] _ in
                _ = await openURL(url)
            }
        case .privacyPolicyButtonTapped:
            guard let url = URL(
                string: Environments.PrivacyPolicyAgreeURLString
            )
            else { return .none }
            return .run { [url] _ in
                _ = await openURL(url)
            }
        case .termsOfServiceButtonTapped:
            guard let url = URL(
                string: Environments.TermsOfServiceURLString
            )
            else { return .none }
            return .run { [url] _ in
                _ = await openURL(url)
            }
        case .withdrawalButtonTapped:
            return .send(.delegate(.showWithdrawal))
        case .retryButtonTapped:
            state.didFailToLoad = false
            state.isLoading = true
            return .send(.feature(.fetchProfile))
        case .loginButtonTapped:
            return .send(.delegate(.showLogin))
        case .logoutButtonTapped:
//            state.isShowPopup = true
            return .send(.feature(.logout))
        case .goalStatusButtonTapped:
            return .send(.delegate(.showMyGoalList))
        case .logoutConfirmButtonTapped:
            return .send(.feature(.logout))
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .logout:
            return .run { send in
                do {
                    try await authClient.logout()
                    await send(.feature(.checkLogout(true)))
                } catch {
                    await send(.feature(.checkLogout(false)))
                }
            }
        case let .checkLogout(isLogout):
            return isLogout ? .send(.delegate(.showGoalList)) : .none
        case let .checkLogin(isLogin):
            state.isLogin = isLogin
            if isLogin == false {
                state.isLoading = false
                return .none
            } else {
                return .send(.feature(.fetchProfile))
            }
        case .fetchProfile:
            return .run { send in
                do {
                    let response = try await menteeClient.fetchMenteeInfo()
                    let content = ProfileContent(
                        name: response.name ?? "",
                        state: .init(
                            inProgressCount: response.inProgressGoalCount ?? 0,
                            completedCount: response.completedGoalCount ?? 0
                        )
                    )
                    await send(
                        .feature(.checkProfileResponse(.success(content)))
                    )
                } catch is NetworkError {
                    await send(
                        .feature(.checkProfileResponse(.networkError))
                    )
                } catch {
                    await send(
                        .feature(.checkProfileResponse(.failed))
                    )
                }
            }
        case let .checkProfileResponse(result):
            switch result {
            case let .success(content):
                state.profile = content
            case .networkError:
                state.didFailToLoad = true
            case .failed:
                break
            }
            state.isLoading = false
            return .none
        }
    }
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        switch action {
        case let .setNickname(nickname):
            state.profile?.name = nickname
            return .none
        default:
            return .none
        }
    }
}
