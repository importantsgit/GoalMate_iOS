//
//  NicknameFeature.swift
//  SignUp
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
        case idle
        case duplicate
        case invalid
        case valid

        var message: String {
            switch self {
            case .idle:
                return ""
            case .duplicate:
                return "이미 있는 닉네임이에요 :("
            case .invalid:
                return "2~5글자 닉네임을 입력해주세요."
            case .valid:
                return "사용 가능한 닉네임이에요 :)"
            }
        }
    }
    @ObservableState
    public struct State: Equatable {
        var nickname: String
        var textFieldState: TextFieldState
        var isSubmitButtonDisabled: Bool
        var isDuplicateCheckButtonDisabled: Bool
        var isLoading: Bool

        public init(
            nickname: String = "",
            textFieldState: TextFieldState = .idle,
            isSubmitButtonDisabled: Bool = true,
            isDuplicateCheckButtonDisabled: Bool = true,
            isLoading: Bool = false
        ) {
            self.nickname = nickname
            self.textFieldState = textFieldState
            self.isSubmitButtonDisabled = isSubmitButtonDisabled
            self.isDuplicateCheckButtonDisabled = isDuplicateCheckButtonDisabled
            self.isLoading = isLoading
        }
    }
    public enum Action: BindableAction {
        case duplicateCheckButtonTapped
        case checkDuplicateResponse(Result<String, NicknameSubmitError>)
        case submitButtonTapped
        case nicknameSubmitted(String)
        case binding(BindingAction<State>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .duplicateCheckButtonTapped:
                state.isLoading = true
                return .run { [nickname = state.nickname] send in
                    try await Task.sleep(for: .seconds(3))
                    await send(.checkDuplicateResponse(.success(nickname)))
                }
            case let .checkDuplicateResponse(result):
                state.isLoading = false
                switch result {
                case .success:
                    state.isSubmitButtonDisabled = false
                    state.isDuplicateCheckButtonDisabled = true
                    state.textFieldState = .valid
                    return .none
                case let .failure(error):
                    state.isSubmitButtonDisabled = false
                    switch error {
                    case .duplicateName:
                        state.isDuplicateCheckButtonDisabled = true
                        state.textFieldState = .duplicate
                    case .networkError:
                        state.textFieldState = .idle
                    case .unknown:
                        state.textFieldState = .idle
                    }
                    return .none
                }
            case .submitButtonTapped:
                state.isLoading = true
                return .run { [nickname = state.nickname] send in
                    try await Task.sleep(for: .seconds(3))
                    await send(.nicknameSubmitted(nickname))
                }
            case .nicknameSubmitted:
                return .none
            case .binding(\.nickname):
                let isValidNickname = (2...5 ~= state.nickname.count)
                state.textFieldState = isValidNickname ? .idle : .invalid
                state.isSubmitButtonDisabled = true
                state.isDuplicateCheckButtonDisabled = isValidNickname == false
                return .none
            case .binding(_):
                return .none
            }
        }
        BindingReducer()
    }
}
