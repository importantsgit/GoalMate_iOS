//
//  LoginFlowFeature.swift
//  Login
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture

@Reducer
public struct LoginFlowFeature {
    @Reducer(state: .equatable)
    public enum Path {
        case login(LoginFeature)
        case signup(NicknameFeature)
        case success(LoginSuccessFeature)
    }

    @ObservableState
    public struct State: Equatable {
        var path = StackState<Path.State>()

        public init() {}
    }

    public enum Action {
        case path(StackActionOf<Path>)
    }

    public var body: some Reducer<State, Action> {
        self.core
            .forEach(\.path, action: \.path)
    }

    @ReducerBuilder<State, Action>
    var core: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
