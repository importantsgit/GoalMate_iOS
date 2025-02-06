//
//  SignUpFeature.swift
//  SignUp
//
//  Created by Importants on 1/6/25.
//

import ComposableArchitecture
import Data
import Dependencies
import UIKit
import Utils

@Reducer
public struct SignUpFeature {
    public enum SignUpProvider {
        case apple
        case kakao
    }
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
        public var message: String {
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
        var pageType: SignUpProcessType
        var isLoading: Bool
        var nickname: String
        var input: String
        var keyboardHeight: Double
        var textFieldState: TextFieldState
        var isSubmitButtonDisabled: Bool
        var isDuplicateCheckButtonDisabled: Bool
        public init(
            pageType: SignUpProcessType = .signUp,
            isLoading: Bool = false,
            nickname: String = "",
            input: String = "",
            keyboardHeight: Double = 0,
            textFieldState: TextFieldState = .idle,
            isSubmitButtonDisabled: Bool = true,
            isDuplicateCheckButtonDisabled: Bool = true
        ) {
            self.pageType = pageType
            self.nickname = nickname
            self.input = input
            self.textFieldState = textFieldState
            self.keyboardHeight = keyboardHeight
            self.isSubmitButtonDisabled = isSubmitButtonDisabled
            self.isDuplicateCheckButtonDisabled = isDuplicateCheckButtonDisabled
            self.isLoading = isLoading
        }
    }
    public enum Action: BindableAction {
        case onAppear
        // Auth
        case signUpButtonTapped(SignUpProvider)
        case signUpSucceeded
        case signUpFailed
        // Nickname
        case updateKeyboardHeight(CGFloat)
        case duplicateCheckButtonTapped
        case checkDuplicateResponse(Result<String, NicknameSubmitError>)
        case submitButtonTapped
        case nicknameSubmitted(String)
        // SignUpSuccess
        case finishButtonTapped
        case binding(BindingAction<State>)
    }
    @Dependency(\.authClient) var authClient
    @Dependency(\.keyboardClient) var keyboardClient
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    for await height in keyboardClient.observeKeyboardHeight() {
                        print("높이: \(height)")
                        await send(.updateKeyboardHeight(height))
                    }
                }
            // Auth
            case let .signUpButtonTapped(provider):
                state.isLoading = true
                return .run { [provider] send in
                    do {
                        let result = try await (
                            provider == .apple ?
                                authClient.appleLogin() :
                                authClient.kakaoLogin()
                        )
                        print(result)
                        let tokens = try await authClient.authenticate(
                            response: result,
                            type: provider == .apple ? .apple : .kakao
                        )
                        print(tokens)
                        await send(.signUpSucceeded)
                    } catch let error as LoginError {
                        print("Error(LoginError): \(error.localizedDescription)")
                        await send(.signUpFailed)
                    } catch let error as NetworkError {
                        print("Error(NetworkError): \(error.localizedDescription)")
                        print(error.localizedDescription)
                        await send(.signUpFailed)
                    } catch {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            case .signUpSucceeded:
                state.isLoading = false
                state.pageType = .nickname
                return .none
            case let .updateKeyboardHeight(height):
                state.keyboardHeight = height
                return .none
            case .signUpFailed:
                state.isLoading = false
                return .none
            // Nickname
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
                state.pageType = .complete
                state.isLoading = false
                return .none
            case .binding(\.input):
                print(state.input, state.nickname)
                if state.input == state.nickname {
                    return .none
                }
                state.nickname = state.input
                return .none
            // Success
            case .finishButtonTapped:
                return .none
            case .binding(_):
                return .none
            }
        }
        BindingReducer()
    }
}
