//
//  GoalCoordinator.swift
//  Goal
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture
import Data
import FeatureCommon
import SwiftUI
import TCACoordinators
import Utils

public struct GoalCoordinatorView: View {
    let store: StoreOf<GoalCoordinator>

    public init(store: StoreOf<GoalCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            Group {
                switch screen.case {
                case let .goalList(store):
                    GoalListView(store: store)
                case let .goalDetail(store):
                    GoalDetailView(store: store)
                case let .goalPurchaseSheet(store):
                    GoalDetailSheetView(store: store)
                        .customSheet(
                            heights: [370],
                            radius: 30,
                            corners: [.topLeft, .topRight]
                        )
                case let .paymentCompleted(store):
                    PaymentCompletedView(store: store)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

@Reducer
public struct GoalCoordinator {
    public init() {}
    @Reducer(state: .equatable)
    public enum Screen {
        case goalList(GoalListFeature)
        case goalDetail(GoalDetailFeature)
        case goalPurchaseSheet(GoalDetailSheetFeature)
        case paymentCompleted(PaymentCompletedFeature)
    }

    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        var routes: IdentifiedArrayOf<Route<Screen.State>>

        public init(
            routes: IdentifiedArrayOf<Route<Screen.State>> = [
                .root(.goalList(.init()), embedInNavigationView: true)
            ]
        ) {
            self.id = UUID()
            self.routes = routes
        }
    }

    public enum Action {
        case router(IdentifiedRouterActionOf<Screen>)
        case delegate(DelegateAction)
    }
    public enum DelegateAction {
        case setTabbarVisibility(Bool)
        case showMyGoal
        case showLogin
    }

    public var body: some Reducer<State, Action> {
        self.core
//            .dependency(\.authClient, .previewValue)
//            .dependency(\.goalClient, .previewValue)
//            .dependency(\.menteeClient, .previewValue)
    }

    @ReducerBuilder<State, Action>
    var core: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .router(.routeAction(
                _,
                action: .goalList(.delegate(.showGoalDetail(contentId))))):
                state.routes
                    .push(.goalDetail(.init(contentId: contentId))
                )
                return .send(.delegate(.setTabbarVisibility(state.routes.count == 1)))
            case .router(.routeAction(
                _,
                action: .goalDetail(.view(.backButtonTapped)))):
                state.routes.pop()
                return .send(.delegate(.setTabbarVisibility(state.routes.count == 1)))
            case .router(.routeAction(
                _,
                action: .goalDetail(.view(.loginButtonTapped)))):
                return .send(.delegate(.showLogin))
            case let .router(.routeAction(
                _,
                action: .goalDetail(.delegate(.showPurchaseSheet(content))))):
                state.routes.presentSheet(
                    .goalPurchaseSheet(
                        .init(
                            content: .init(
                                contentId: content.id,
                                title: content.details.title,
                                mentor: content.details.mentor,
                                originalPrice: content.originalPrice,
                                discountedPrice: content.discountedPrice
                            )
                        )
                    )
                )
                return .none
            case let .router(.routeAction(
                _,
                action: .goalPurchaseSheet(.delegate(.finishPurchase(content))))):
                return Effect.routeWithDelaysIfUnsupported(state.routes, action: \.router) {
                    $0.dismiss()
                    $0.push(.paymentCompleted(
                        .init(content: .init(
                            contentId: content.contentId,
                            title: content.title,
                            mentor: content.mentor,
                            originalPrice: content.originalPrice,
                            discountedPrice: content.discountedPrice
                        )))
                    )
                }
            case let .router(.routeAction(
                _,
                action: .goalPurchaseSheet(.delegate(.failed(message))))):
                guard case let .goalDetail(goalDetail) = state.routes.first?.screen
                else { return .none }
                return .send(.router(.routeAction(
                    id: goalDetail.id,
                    action: .goalDetail(.feature(.showToast(message))))))
            case .router(.routeAction(
                _,
                action: .paymentCompleted(.backButtonTapped))):
                state.routes.pop()
                return .none
            case .router(.routeAction(
                _,
                action: .paymentCompleted(.startButtonTapped))):
                state.routes.popToRoot()
                return .send(.delegate(.showMyGoal))
            default: return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

extension GoalCoordinator.Screen.State: Identifiable {
    public var id: UUID {
    switch self {
    case let .goalList(state):
      state.id
    case let .goalDetail(state):
      state.id
    case let .goalPurchaseSheet(state):
        state.id
    case let .paymentCompleted(state):
        state.id
    }
  }
}
