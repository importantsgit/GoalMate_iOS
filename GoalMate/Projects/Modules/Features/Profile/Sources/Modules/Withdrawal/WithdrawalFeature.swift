//
//  WithdrawalFeature.swift
//  FeatureProfile
//
//  Created by Importants on 2/4/25.
//

import ComposableArchitecture

@Reducer
public struct WithdrawalFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
    }
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .binding:
                return .none
            }
        }
        BindingReducer()
    }
}
