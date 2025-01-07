//
//  LoginFeature.swift
//  Login
//
//  Created by Importants on 1/6/25.
//

import ComposableArchitecture

@Reducer
public struct LoginFeature {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    public enum Action {
        case appleButtonTapped
        case kakaoButtonTapped
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .appleButtonTapped:
                return .none
            case .kakaoButtonTapped:
                return .none
            }
        }
    }
}
