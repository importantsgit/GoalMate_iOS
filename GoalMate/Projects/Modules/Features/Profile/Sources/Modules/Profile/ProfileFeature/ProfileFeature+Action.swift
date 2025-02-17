//
//  ProfileFeature+Action.swift
//  FeatureProfile
//
//  Created by Importants on 2/12/25.
//

import ComposableArchitecture
import Foundation
import Utils

extension ProfileFeature {
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
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
                        .feature(.fetchMyGoalCount(.success(content)))
                    )
                } catch {
                    await send(
                        .feature(.fetchMyGoalCount(.failure(error)))
                    )
                }
            }
        }
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .nicknameEditButtonTapped:
            return .send(
                .feature(.showNicknameEdit(state.profile?.name ?? ""))
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
            return .none
        case let .setNickname(nickname):
            state.profile?.name = nickname
            return .none
        case .retryButtonTapped:
            state.didFailToLoad = false
            state.isLoading = true
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
                        .feature(.fetchMyGoalCount(.success(content)))
                    )
                } catch {
                    await send(
                        .feature(.fetchMyGoalCount(.failure(error)))
                    )
                }
            }
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .showNicknameEdit:
            return .none
        case let .fetchMyGoalCount(result):
            switch result {
            case  let .success(content):
                state.profile = content
            case let .failure(error):
                print(error)
                state.didFailToLoad = true
            }
            state.isLoading = false
            return .none
        }
    }
}
