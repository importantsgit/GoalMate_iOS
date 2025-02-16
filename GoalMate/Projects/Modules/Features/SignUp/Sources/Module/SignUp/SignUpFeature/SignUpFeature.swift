//
//  SignUpFeature.swift
//  SignUp
//
//  Created by Importants on 1/6/25.
//

import ComposableArchitecture
import Data
import Dependencies
import FeatureCommon
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
    // Swift의 Observation 프레임워크를 TCA에 통합
    // iOS 17 미만에서는 WithPerceptionTracking 필요
    @ObservableState // obserableframework
    public struct State: Equatable {
        var id: UUID
        // 페이지 상태
        var pageType: SignUpProcessType
        var isLoading: Bool
        var toastState: ToastState
        // 닉네임 입력 관련 상태
        var nicknameFormState: NicknameFormState
        // 키보드 상태
        var keyboardHeight: Double
        // textFieldInput
        var nickname: String // 닉네임
        public struct NicknameFormState: Equatable {
            var inputText: String
            var validationState: TextFieldState
            var isSubmitEnabled: Bool
            var isDuplicateCheckEnabled: Bool
            public init(
                validationState: TextFieldState = .idle,
                isSubmitEnabled: Bool = false,
                isDuplicateCheckEnabled: Bool = false
            ) {
                self.inputText = ""
                self.validationState = validationState
                self.isSubmitEnabled = isSubmitEnabled
                self.isDuplicateCheckEnabled = isDuplicateCheckEnabled
            }
        }
        public init(
            id: UUID = UUID(),
            pageType: SignUpProcessType = .signUp,
            isLoading: Bool = false,
            nicknameInput: NicknameFormState = .init(),
            keyboardHeight: Double = 0
        ) {
            self.id = id
            self.pageType = pageType
            self.isLoading = isLoading
            self.toastState = .hide
            self.nicknameFormState = nicknameInput
            self.keyboardHeight = keyboardHeight
            self.nickname = ""
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case auth(AuthAction)
        case nickname(NicknameAction)
        case signUpSuccess(SignUpSuccessAction)
        case feature(FeatureAction)
        case binding(BindingAction<State>)
        case nicknameTextInputted(String)
    }
    public enum ViewCyclingAction {
        case onAppear
    }
    public enum AuthAction {
        case signUpButtonTapped(SignUpProvider)
        case backButtonTapped
    }
    public enum NicknameAction {
        case nicknameTextInputted(String)
        case duplicateCheckButtonTapped
        case submitButtonTapped
    }
    public enum SignUpSuccessAction {
        case finishButtonTapped
    }
    public enum FeatureAction {
        case checkSignUpResponse(Bool)
        case showNicknameView
        case checkDuplicateResponse(Result<String, NicknameSubmitError>)
        case nicknameSubmitted(Result<String, NicknameSubmitError>)
        case updateKeyboardHeight(CGFloat)
    }
    @Dependency(\.authClient) var authClient
    @Dependency(\.keyboardClient) var keyboardClient
    @Dependency(\.nicknameClient) var nicknameClient
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .viewCycling(action):
                return reduce(into: &state, action: action)
            case let .auth(action):
                return reduce(into: &state, action: action)
            case let .nickname(action):
                return reduce(into: &state, action: action)
            case let .signUpSuccess(action):
                return reduce(into: &state, action: action)
            case let .feature(action):
                return reduce(into: &state, action: action)
                // Success
            case let .nicknameTextInputted(text):
                print(text)
                return .none
            case .binding:
                print(action)
                return .none
            }
        }
    }
}
