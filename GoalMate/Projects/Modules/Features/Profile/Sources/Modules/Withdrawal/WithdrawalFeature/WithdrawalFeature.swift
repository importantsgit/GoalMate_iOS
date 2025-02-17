//
//  WithdrawalFeature.swift
//  FeatureProfile
//
//  Created by Importants on 2/4/25.
//

import ComposableArchitecture
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
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
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
            Result<String, WithdrawalSubmitError>
        )
    }
    @Dependency(\.keyboardClient) var keyboardClient
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
            case .binding:
                print(action)
                return .none
            }
        }
        BindingReducer()
    }
}
