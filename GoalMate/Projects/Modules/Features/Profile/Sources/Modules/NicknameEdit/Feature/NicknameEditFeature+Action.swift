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
                for await height in environmentClient.observeKeyboardHeight() {
                    print("높이: \(height)")
                    await send(.feature(.updateKeyboardHeight(height)))
                }
            }
        case .onDisappear:
            return .send(.delegate(.dismiss))
        }
    }
    // MARK: View
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .duplicateCheckButtonTapped:
            state.isLoading = true
            return .run { [nickname = state.inputText] send in
                do {
                    let isUniqueNickname = try await menteeClient.isUniqueNickname(nickname)
                    await send(
                        .feature(
                            .checkDuplicateResponse(
                                isUniqueNickname ?
                                    .success(nickname) :
                                        .duplicateName
                            )
                        )
                    )
                } catch let error as NetworkError {
                    print(error)
                    await send(
                        .feature(
                            .checkDuplicateResponse(
                                .networkError
                            )
                        )
                    )
                }
            }
        case .submitButtonTapped:
            state.isLoading = true
            return .run { [nickname = state.inputText] send in
                do {
                    try await menteeClient.setNickname(nickname)
                    await send(.feature(.nicknameSubmitted(.success(nickname))))
                } catch let error as NetworkError {
                    // 네트워크 오류 시 error 처리
                    print(error.localizedDescription)
                    await send(.feature(.nicknameSubmitted(.networkError)))
                }
            }
        }
    }
    // MARK: Feature
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case let .checkDuplicateResponse(result):
            switch result {
            case .success:
                state.nicknameFormState.isDuplicateCheckEnabled = false
                state.nicknameFormState.isSubmitEnabled = true
                state.nicknameFormState.validationState = .valid
            case .networkError:
                state.toastState = .display(
                    "네트워크에 문제가 발생했습니다."
                )
            case .duplicateName, .unknown:
                state.nicknameFormState.isDuplicateCheckEnabled = false
                state.nicknameFormState.isSubmitEnabled = false
                state.nicknameFormState.validationState = result == .duplicateName ?
                    .duplicate :
                    .idle
            }
            state.isLoading = false
            return .none
        case let .nicknameSubmitted(result):
            switch result {
            case let .success(nickname):
                return .send(.delegate(.nicknameEditCompleted(nickname)))
            default:
                state.toastState = .display("닉네임을 저장하지 못했습니다.")
            }
            state.isLoading = false
            return .none
        case let .updateKeyboardHeight(height):
            state.keyboardHeight = height
            return .none
        }
    }
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
