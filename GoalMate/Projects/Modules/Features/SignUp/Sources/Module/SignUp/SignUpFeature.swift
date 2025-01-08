//
//  SignUpFeature.swift
//  SignUp
//
//  Created by Importants on 1/6/25.
//

import ComposableArchitecture

@Reducer
public struct SignUpFeature {
    public enum SignUpProvider {
        case apple
        case kakao
    }
    @ObservableState
    public struct State: Equatable {
        var isLoading: Bool
        public init(
            isLoading: Bool = false
        ) {
            self.isLoading = isLoading
        }
    }
    public enum Action: BindableAction {
        case signUpButtonTapped(SignUpProvider)
        case signUpSucceeded
        case binding(BindingAction<State>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .signUpButtonTapped(provider):
                state.isLoading = true
                print(provider)
                return .run { send in
                    try await Task.sleep(for: .seconds(3))
                    await send.callAsFunction(.signUpSucceeded)
                }
            case .signUpSucceeded:
                state.isLoading = false
                return .none
            case .binding(_):
                return .none
            }
        }
        BindingReducer()
    }
}
