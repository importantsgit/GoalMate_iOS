//
//  LoginSuccessFeature.swift
//  Login
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture

@Reducer
struct LoginSuccessFeature {
    @ObservableState
    struct State: Equatable {
        var nickName: String = ""
    }
    enum Action {
        case confirmButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .confirmButtonTapped:
                return .none
            }
        }
    }
}
