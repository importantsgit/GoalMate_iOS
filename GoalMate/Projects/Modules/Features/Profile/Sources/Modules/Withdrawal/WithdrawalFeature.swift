//
//  WithdrawalFeature.swift
//  FeatureProfile
//
//  Created by Importants on 2/4/25.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct WithdrawalFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        public init() {
            self.id = UUID()
        }
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
