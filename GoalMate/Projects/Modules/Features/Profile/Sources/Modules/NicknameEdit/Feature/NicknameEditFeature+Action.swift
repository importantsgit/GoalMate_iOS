//
//  NicknameEditFeature+Action.swift
//  FeatureProfile
//
//  Created by Importants on 2/17/25.
//

import ComposableArchitecture
import Data

extension NicknameEditFeature {
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
        case .nicknameTextInputted(let text):
            print("text: \(text)")
            guard state.nicknameFormState.inputText != text
            else { return .none }
            state.nicknameFormState.inputText = text
            let isValidNickname = (2...5 ~= text.count)
            print("isValid??: \(isValidNickname)")
            state.nicknameFormState.validationState = isValidNickname ?
                .idle :
                .invalid
            state.nicknameFormState.isDuplicateCheckEnabled = isValidNickname
            state.nicknameFormState.isSubmitEnabled = false
            return .none
        case .duplicateCheckButtonTapped:
            state.isLoading = true
            return .run { [nickname = state.nicknameFormState.inputText] send in
                do {
                    let isUniqueNickname = try await nicknameClient.isUniqueNickname(nickname)
                    await send(
                        .feature(
                            .checkDuplicateResponse(
                                isUniqueNickname ?
                                    .success(nickname) :
                                    .failure(.duplicateName)
                            )
                        )
                    )
                } catch let error as NetworkError {
                    print(error)
                    await send(
                        .feature(
                            .checkDuplicateResponse(
                                .failure(.networkError)
                            )
                        )
                    )
                }
            }
        case .submitButtonTapped:
            state.isLoading = true
            return .run { [nickname = state.nicknameFormState.inputText] send in
                do {
                    try await nicknameClient.setNickname(nickname)
                    await send(.feature(.nicknameSubmitted(.success(nickname))))
                } catch let error as NetworkError {
                    // 네트워크 오류 시 error 처리
                    print(error.localizedDescription)
                    await send(.feature(.nicknameSubmitted(.failure(.networkError))))
                }
            }
        }
    }
    // MARK: Feature
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case let .checkDuplicateResponse(result):
            state.isLoading = false
            switch result {
            case .success:
                state.nicknameFormState.isDuplicateCheckEnabled = false
                state.nicknameFormState.isSubmitEnabled = true
                state.nicknameFormState.validationState = .valid
                return .none
            case let .failure(error):
                if case .networkError = error {
                    state.toastState = .display(
                        "네트워크에 문제가 발생했습니다."
                    )
                    return .none
                }
                state.nicknameFormState.isDuplicateCheckEnabled = false
                state.nicknameFormState.isSubmitEnabled = false
                state.nicknameFormState.validationState = error == .duplicateName ?
                    .duplicate :
                    .idle
                return .none
            }
        case let .nicknameSubmitted(result):
            state.isLoading = false
            switch result {
            case .success(_):
                state.nickname = state.nicknameFormState.inputText
            case .failure(_):
                state.toastState = .display("닉네임을 저장하지 못했습니다.")
            }
            return .none
        case let .updateKeyboardHeight(height):
            state.keyboardHeight = height
            return .none
        }
    }
}
