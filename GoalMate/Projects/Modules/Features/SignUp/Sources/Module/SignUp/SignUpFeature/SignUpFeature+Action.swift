//
//  SignUpFeature+Action.swift
//  FeatureSignUp
//
//  Created by Importants on 2/9/25.
//

import ComposableArchitecture
import Data

extension SignUpFeature {
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
        }
    }
    // MARK: Auth
    func reduce(into state: inout State, action: AuthAction) -> Effect<Action> {
        switch action {
        case .backButtonTapped:
            return .send(.delegate(.loginFinished))
        case let .signUpButtonTapped(provider):
            state.isLoading = true
            return .run { [provider] send in
                do {
                    let result = try await
                        (provider == .apple ?
                         authClient.loginWithApple() :
                            authClient.loginWithKakao())
                    switch result {
                    case .signIn: // 로그인 성공
                        await send(.feature(.checkAuthenticationResponse(.success(.signIn))))
                    case .signUp: // 회원가입 성공
                        await send(.feature(.checkAuthenticationResponse(.success(.signUp))))
                    }
                } catch is NetworkError {
                    await send(.feature(.checkAuthenticationResponse(.networkError)))
                } catch {
                    await send(.feature(.checkAuthenticationResponse(.failed)))
                }
            }
        }
    }
    // MARK: Nickname
    func reduce(into state: inout State, action: NicknameAction) -> Effect<Action> {
        switch action {
        case .duplicateCheckButtonTapped:
            state.isLoading = true
            return .run { [nickname = state.nicknameFormState.inputText] send in
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
                    if case let .statusCodeError(code) = error,
                       code == 409 {
                        await send(.feature(.checkDuplicateResponse(.duplicateName)))
                        return
                    }
                    await send(.feature(.checkDuplicateResponse(.networkError)))
                } catch {
                    await send(.feature(.checkDuplicateResponse(.unknown)))
                }
            }
        case .submitButtonTapped:
            state.isLoading = true
            return .run { [nickname = state.nicknameFormState.inputText] send in
                do {
                    try await menteeClient.setNickname(nickname)
                    await send(.feature(.nicknameSubmitted(.success(nickname))))
                } catch let error as NetworkError {
                    // 네트워크 오류 시 error 처리
                    if case let .statusCodeError(code) = error,
                       code == 409 {
                        await send(.feature(.checkDuplicateResponse(.duplicateName)))
                        return
                    }
                    print(error.localizedDescription)
                    await send(.feature(.nicknameSubmitted(.networkError)))
                } catch {
                    await send(.feature(.nicknameSubmitted(.failed)))
                }
            }
        }
    }
    // MARK: SignUp
    func reduce(into state: inout State, action: SignUpSuccessAction) -> Effect<Action> {
        switch action {
        case .finishButtonTapped:
            return .send(.delegate(.loginFinished))
        }
    }
    // MARK: Feature
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .getNickname:
            state.isLoading = true
            return .run { send in
                do {
                    let response = try await menteeClient.fetchMenteeInfo()
                    guard let nickname = response.name
                    else {
                        await send(.feature(.checkGetNicknameResponse(.failed)))
                        return
                    }
                    await send(.feature(.checkGetNicknameResponse(.success(nickname))))
                } catch is NetworkError {
                    await send(.feature(.checkGetNicknameResponse(.networkError)))
                } catch {
                    await send(.feature(.checkGetNicknameResponse(.failed)))
                }
            }
        case let .checkGetNicknameResponse(result):
            state.isLoading = false
            switch result {
            case let .success(nickname):
                return .send(.nicknameTextInputted(nickname))
            case .networkError, .failed:
                return .none
            }
        case let .checkAuthenticationResponse(result):
            state.isLoading = false
            switch result {
            case let .success(type):
                switch type {
                case .signIn:
                    return .send(.delegate(.loginFinished))
                case .signUp:
                    return .send(.delegate(.authenticationCompleted))
                }
            case .networkError:
                state.toastState = .display("네트워크에 문제가 발생했습니다.")
            case .failed:
                state.toastState = .display("인증이 실패했습니다.")
            }
            return .none
        case let .checkDuplicateResponse(result):
            switch result {
            case .success(_):
                state.nicknameFormState.isDuplicateCheckEnabled = false
                state.nicknameFormState.isSubmitEnabled = true
                state.nicknameFormState.validationState = .valid
            case .duplicateName, .unknown:
                state.nicknameFormState.isDuplicateCheckEnabled = false
                state.nicknameFormState.isSubmitEnabled = false
                state.nicknameFormState.validationState = result == .duplicateName ?
                    .duplicate :
                    .idle
            case .networkError:
                state.toastState = .display("네트워크에 문제가 발생했습니다.")
            }
            state.isLoading = false
            return .none
        case let .nicknameSubmitted(result):
            switch result {
            case let .success(nickname):
                state.nickname = state.nicknameFormState.inputText
                state.pageType = .complete
            case .networkError:
                state.toastState = .display("네트워크에 문제가 발생했습니다.")
            case .failed:
                state.toastState = .display("닉네임을 저장하지 못했습니다.")
            }
            state.isLoading = false
            return .none
        case let .updateKeyboardHeight(height):
            state.keyboardHeight = height
            return .none
        }
    }
    // MARK: delegate
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        switch action {
        case .termsAgreementCompleted:
            state.pageType = .nickname
            return .send(.feature(.getNickname))
        default: return .none
        }
    }
}
