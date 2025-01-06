//
//  LoginFeature.swift
//  Login
//
//  Created by 이재훈 on 1/6/25.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct LoginFeature {
    @ObservableState
    struct State: Equatable {
    }

    enum Action: Equatable {
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
