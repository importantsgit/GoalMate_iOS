//
//  NicknameEditFeature.swift
//  FeatureProfile
//
//  Created by Importants on 2/17/25.
//

import ComposableArchitecture
import Data
import Dependencies
import FeatureCommon
import UIKit
import Utils

@Reducer
public struct NicknameEditFeature {
    // Swift의 Observation 프레임워크를 TCA에 통합
    // iOS 17 미만에서는 WithPerceptionTracking 필요
    @ObservableState // obserableframework
    public struct State: Equatable {
        var id: UUID
        var isLoading: Bool
        var toastState: ToastState
        // 닉네임 입력 관련 상태
        var nicknameFormState: NicknameFormState
        // 키보드 상태
        var keyboardHeight: Double
        // textFieldInput
        var nickname: String // 닉네임
        var inputText: String
        public struct NicknameFormState: Equatable {
            var validationState: TextFieldState
            var isSubmitEnabled: Bool
            var isDuplicateCheckEnabled: Bool
            public init(
                validationState: TextFieldState = .idle,
                isSubmitEnabled: Bool = false,
                isDuplicateCheckEnabled: Bool = false
            ) {
                self.validationState = validationState
                self.isSubmitEnabled = isSubmitEnabled
                self.isDuplicateCheckEnabled = isDuplicateCheckEnabled
            }
        }
        public init(
            nickname: String,
            isLoading: Bool = false,
            keyboardHeight: Double = 0
        ) {
            self.id = UUID()
            self.isLoading = isLoading
            self.toastState = .hide
            self.nicknameFormState = .init()
            self.keyboardHeight = keyboardHeight
            self.nickname = nickname
            self.inputText = nickname
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
        case nicknameTextInputted(String)
    }
    public enum ViewCyclingAction {
        case onAppear
        case onDisappear
    }
    public enum ViewAction {
        case duplicateCheckButtonTapped
        case submitButtonTapped
    }
    public enum FeatureAction {
        case checkDuplicateResponse(NicknameSubmitResult)
        case nicknameSubmitted(NicknameSubmitResult)
        case updateKeyboardHeight(CGFloat)
    }
    public enum DelegateAction {
        case setNickname(String)
        case nicknameEditCompleted(String)
        case dismiss
    }
    @Dependency(\.authClient) var authClient
    @Dependency(\.environmentClient) var environmentClient
    @Dependency(\.menteeClient) var menteeClient
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .nicknameTextInputted(nickname):
                guard state.inputText != nickname
                else { return .none }
                state.inputText = nickname
                let isValidNickname = (2...5 ~= nickname.count)
                state.nicknameFormState.validationState = isValidNickname ?
                    .idle :
                    .invalid
                state.nicknameFormState.isDuplicateCheckEnabled = isValidNickname
                state.nicknameFormState.isSubmitEnabled = false
                return .none
            case let .viewCycling(action):
                return reduce(into: &state, action: action)
            case let .view(action):
                return reduce(into: &state, action: action)
            case let .feature(action):
                return reduce(into: &state, action: action)
            case let .delegate(action):
                return reduce(into: &state, action: action)
            case .binding:
                print(action)
                return .none
            }
        }
    }
}

extension NicknameEditFeature {
    public enum NicknameSubmitResult: Equatable {
        case success(String)
        case duplicateName
        case networkError
        case unknown
        public static func == (lhs: NicknameSubmitResult, rhs: NicknameSubmitResult) -> Bool {
            switch (lhs, rhs) {
            case (.success(let lhsValue), .success(let rhsValue)):
                return lhsValue == rhsValue
            case (.duplicateName, .duplicateName):
                return true
            case (.networkError, .networkError):
                return true
            case (.unknown, .unknown):
                return true
            default:
                return false
            }
        }
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
}
