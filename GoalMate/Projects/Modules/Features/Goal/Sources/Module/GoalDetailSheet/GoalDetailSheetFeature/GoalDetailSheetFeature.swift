//
//  GoalDetailSheetFeature.swift
//  FeatureGoal
//
//  Created by Importants on 2/16/25.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct GoalDetailSheetFeature {
    @ObservableState
    public struct State: Equatable {
        var id: UUID
        let content: GoalDetailSheetContent
        public init(
            content: GoalDetailSheetContent
        ) {
            self.id = UUID()
            self.content = content
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {}
    public enum ViewAction {
        case purchaseButtonTapped
    }
    public enum FeatureAction {
        case checkPurchaseResponse(Result<GoalDetailSheetContent, Error>)
    }
    @Dependency(\.menteeClient) var menteeClient
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
            case .binding(_):
                return .none
            }
        }
    }
}
