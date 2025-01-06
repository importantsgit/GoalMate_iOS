//
//  LoginFeature.swift
//  Login
//
//  Created by Importants on 1/6/25.
//

import ComposableArchitecture

@Reducer
struct LoginFeature {
    @ObservableState
    struct State: Equatable {}
    enum Action {
        case appleButtonTapped
        case kakaoButtonTapped
    }

    var body: some Reducer<State, Action> {
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
