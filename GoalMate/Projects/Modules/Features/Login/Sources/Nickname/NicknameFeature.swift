//
//  NicknameFeature.swift
//  Login
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
public struct NicknameFeature {
    public init() {}

    public enum NicknameSubmitError: Error {
        case duplicateName
        case networkError
        case unknown
    }

    public enum TextFieldState {
        case duplicate
        case invalid
        case valid
    }
    @ObservableState
    public struct State: Equatable {
        var nickname: String
        var textFieldState: TextFieldState
        var isSubmitButtonDisabled: Bool
        var isLoading: Bool

        public init(
            nickname: String = "",
            textFieldState: TextFieldState = .valid,
            isSubmitButtonDisabled: Bool = true,
            isLoading: Bool = false
        ) {
            self.nickname = nickname
            self.textFieldState = textFieldState
            self.isSubmitButtonDisabled = isSubmitButtonDisabled
            self.isLoading = isLoading
        }
    }
    public enum Action: BindableAction {
        case submitButtonTapped
        case nicknameSubmitted(Result<Void, NicknameSubmitError>)
        case binding(BindingAction<State>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .submitButtonTapped:
                state.isLoading = true

                return .run { [nickname = state.nickname] send in
                    try await Task.sleep(for: .seconds(3))
                    await send(.nicknameSubmitted(.success(())))
                }
            case let .nicknameSubmitted(result):
                state.isLoading = false
                switch result {
                case .success:
                    return .none
                case let .failure(error):
                    state.isSubmitButtonDisabled = false
                    switch error {
                    case .duplicateName:
                        state.textFieldState = .duplicate
                    case .networkError:
                        state.textFieldState = .duplicate
                    case .unknown:
                        state.textFieldState = .duplicate
                    }
                    return .none
                }
            case .binding(\.nickname):
                let isValidNickname = (2...5 ~= state.nickname.count)
                state.textFieldState = .valid
                state.isSubmitButtonDisabled = isValidNickname == false
                return .none
            case .binding(_):
                return .none
            }
        }
        BindingReducer()
    }
}
