//
//  GoalDetailSheetFeature.swift
//  FeatureGoal
//
//  Created by Importants on 2/16/25.
//

import ComposableArchitecture
import FeatureCommon
import Foundation

@Reducer
public struct GoalDetailSheetFeature {
    @ObservableState
    public struct State: Equatable {
        var id: UUID
        let content: GoalDetailSheetContent
        var toastState: ToastState
        public init(
            content: GoalDetailSheetContent
        ) {
            self.id = UUID()
            self.content = content
            self.toastState = .hide
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {}
    public enum ViewAction {
        case purchaseButtonTapped
    }
    public enum FeatureAction {
        case checkPurchaseResponse(PurchaseResult)
    }
    public enum DelegateAction {
        case finishPurchase(GoalDetailSheetContent)
        case failed(String)
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
            case let .delegate(action):
                return reduce(into: &state, action: action)
            case .binding(_):
                return .none
            }
        }
    }
}

extension GoalDetailSheetFeature {
    public enum PurchaseResult {
        case success(GoalDetailSheetContent)
        case failed(String)
        case networkError
    }
}
