//
//  WithdrawalFeature.swift
//  FeatureProfile
//
//  Created by Importants on 2/4/25.
//

import ComposableArchitecture
import FeatureCommon
import Foundation

@Reducer
public struct WithdrawalFeature {
    public enum WithdrawalSubmitError: Error {
        case duplicateName
        case networkError
        case unknown
    }
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        var keyboardHeight: Double
        var inputText: String
        var confirmText: String
        var isSubmitEnabled: Bool
        var toastState: ToastState
        public init(
            keyboardHeight: Double = 0,
            inputText: String = "",
            confirmText: String = "",
            isSubmitEnabled: Bool = false
        ) {
            self.id = UUID()
            self.keyboardHeight = keyboardHeight
            self.inputText = inputText
            self.confirmText = confirmText
            self.isSubmitEnabled = isSubmitEnabled
            self.toastState = .hide
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {
        case onAppear
    }
    public enum ViewAction {
        case backButtonTapped
        case confirmButtonTapped
        case nicknameTextInputted(String)
    }
    public enum FeatureAction {
        case updateKeyboardHeight(Double)
        case checkWithdrawalResponse(
            Result<Void, WithdrawalSubmitError>
        )
    }
    public enum DelegateAction {
        case closeView
    }
    @Dependency(\.authClient) var authClient
    @Dependency(\.environmentClient) var environmentClient
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
            case let .delegate(action):
                return reduce(into: &state, action: action)
            case .binding:
                print(action)
                return .none
            }
        }
        BindingReducer()
    }
}
