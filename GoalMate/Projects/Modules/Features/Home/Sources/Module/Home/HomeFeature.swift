//
//  HomeFeature.swift
//  Home
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture

@Reducer
public struct HomeFeature {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    public enum Action {
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            return .none
        }
    }
}
