//
//  MainViewFeature.swift
//  DemoSignUpFeature
//
//  Created by Importants on 2/28/25.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct MainFeature {
    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        public init() {
            self.id = UUID()
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {
        case onAppear
    }
    public enum ViewAction {
        case loginFlow
        case signUpFlow
    }
    public enum FeatureAction {
    }
    public enum DelegateAction {
        case showLogin
        case showSignUp
    }
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .viewCycling(action):
                return reduce(into: &state, action: action)
            case let .view(action):
                return reduce(into: &state, action: action)
            case let .feature(action):
                return reduce(into: &state, action: action)
            case let .delegate(action):
                return reduce(into: &state, action: action)
            case .binding:
                return .none
            }
        }
    }
}

extension MainFeature {
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        return .none
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .loginFlow:
            return .send(.delegate(.showLogin))
        case .signUpFlow:
            return .send(.delegate(.showSignUp))
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        return .none
    }
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}

