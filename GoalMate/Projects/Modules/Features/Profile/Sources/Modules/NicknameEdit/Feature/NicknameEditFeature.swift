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
                nickname: String,
                validationState: TextFieldState = .idle,
                isSubmitEnabled: Bool = false,
                isDuplicateCheckEnabled: Bool = false
            ) {
                self.inputText = nickname
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
            self.nicknameFormState = .init(nickname: nickname)
            self.keyboardHeight = keyboardHeight
            self.nickname = nickname
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case binding(BindingAction<State>)
        case nicknameTextInputted(String)
    }
    public enum ViewCyclingAction {
        case onAppear
    }
    public enum ViewAction {
        case nicknameTextInputted(String)
        case duplicateCheckButtonTapped
        case submitButtonTapped
    }
    public enum FeatureAction {
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
            case let .view(action):
                return reduce(into: &state, action: action)
            case let .feature(action):
                return reduce(into: &state, action: action)
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
