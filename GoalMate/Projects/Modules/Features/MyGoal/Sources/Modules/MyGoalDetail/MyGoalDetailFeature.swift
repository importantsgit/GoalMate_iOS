//
//  MyGoalDetailFeature.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import ComposableArchitecture

@Reducer
public struct MyGoalDetailFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
    }
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
        BindingReducer()
    }
}
