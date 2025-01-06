//
//  NickNameFeature.swift
//  Login
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct NickNameFeature {
    @ObservableState
    struct State: Equatable {
        var nickname: String = ""
    }
    enum Action: BindableAction {
        case binding(BindingAction<State>)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding(\.nickname):
                // TODO: State 변환
                return .none
            case .binding(_):
                return .none
            }
        }
        BindingReducer()
    }
}
