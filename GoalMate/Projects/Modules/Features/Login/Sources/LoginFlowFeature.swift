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
    public enum Destination {
        case login(LoginFeature)
        case signup(NicknameFeature)
        case success(LoginSuccessFeature)
    }

    @ObservableState
    public struct State: Equatable {
        @Presents public var destination: Destination.State?
        
        public init(destination: Destination.State? = nil) {
            self.destination = destination
        }
    }

    public enum Action {
        
    }

    public var body: some Reducer<State, Action> {
        self.core
    }

    @ReducerBuilder<State, Action>
    var core: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
