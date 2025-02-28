//
//  PaymentCompletedFeature.swift
//  FeatureHome
//
//  Created by Importants on 1/20/25.
//

import Foundation

import ComposableArchitecture
import FeatureCommon
import SwiftUI

@Reducer
public struct PaymentCompletedFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        var content: PaymentCompletedContent
        public init(
            content: PaymentCompletedContent
        ) {
            self.id = UUID()
            self.content = content
        }
    }

    public enum Action: BindableAction {
        case view(ViewAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
    }
    public enum ViewAction {
        case backButtonTapped
        case startButtonTapped
    }
    public enum DelegateAction {
        case closeView
        case showMyGoalDetail(Int)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .view(action):
                return reduce(into: &state, action: action)
            case let .delegate(action):
                return reduce(into: &state, action: action)
            case .binding:
                return .none
            }
        }
        BindingReducer()
    }
}

extension PaymentCompletedFeature {
    // MARK: View
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .backButtonTapped:
            return .send(.delegate(.closeView))
        case.startButtonTapped:
            guard let contentId = state.content.menteeGoalId
            else { return .none }
            return .send(.delegate(.showMyGoalDetail(contentId)))
        }
    }
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
