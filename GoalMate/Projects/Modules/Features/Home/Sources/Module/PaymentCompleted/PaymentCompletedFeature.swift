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
        var content: PaymentCompletedItem
        public init(
            content: PaymentCompletedItem
        ) {
            self.content = content
        }
    }

    public enum Action: BindableAction {
        case backButtonTapped
        case startButtonTapped
        case binding(BindingAction<State>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .startButtonTapped:
                return .none
            case .binding:
                return .none
            }
        }
        BindingReducer()
    }
}
