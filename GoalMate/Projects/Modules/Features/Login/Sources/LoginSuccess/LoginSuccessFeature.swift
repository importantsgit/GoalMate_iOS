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
        var nickName: String = "임폴턴트"
    }
    enum Action {
        case startButtonTapped
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .startButtonTapped:
                return .none
            }
        }
    }
}
