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
                for await height in keyboardClient.observeKeyboardHeight() {
                    print("높이: \(height)")
                    await send(.feature(.updateKeyboardHeight(height)))
                }
            }
        }
    }
    // MARK: View
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .backButtonTapped:
            return .none
        case .confirmButtonTapped:
            return .run { send in
                
            }
        case let .nicknameTextInputted(text):
            print("text: \(text)")
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
                break
            case .failure:
                break
            }
            return .none
        case let .updateKeyboardHeight(height):
            state.keyboardHeight = height
            return .none
        }
    }
}
