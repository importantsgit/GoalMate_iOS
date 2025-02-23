//
//  WithdrawalFeature+Action.swift
//  FeatureProfile
//
//  Created by Importants on 2/18/25.
//

import ComposableArchitecture
import Data

extension WithdrawalFeature {
    // MARK: ViewCycling
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                for await height in environmentClient.observeKeyboardHeight() {
                    await send(.feature(.updateKeyboardHeight(height)))
                }
            }
        }
    }
    // MARK: View
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .backButtonTapped:
            return .send(.delegate(.closeView))
        case .confirmButtonTapped:
            return .run { send in
                do {
                    try await authClient.withdraw()
                    await send(.feature(.checkWithdrawalResponse(
                        .success(())))
                    )
                } catch {
                    print(error)
                    await send(.feature(
                        .checkWithdrawalResponse(.failure(.networkError)))
                    )
                }
            }
        case let .nicknameTextInputted(text):
            guard state.inputText != text
            else { return .none }
            state.inputText = text
            state.isSubmitEnabled = "탈퇴" == text
            return .none
        }
    }
    // MARK: Feature
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case let .checkWithdrawalResponse(result):
            switch result {
            case .success:
                return .send(.feature(.finish))
            case .failure:
                state.toastState = .display(
                    "네트워크에 문제가 발생했습니다."
                )
            }
            return .none
        case let .updateKeyboardHeight(height):
            state.keyboardHeight = height
            return .none
        case .finish:
            return .none
        }
    }
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
