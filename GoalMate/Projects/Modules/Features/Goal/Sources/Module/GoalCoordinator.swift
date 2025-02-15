//
//  GoalCoordinator.swift
//  Goal
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture
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
                case let .paymentCompleted(store):
                    PaymentCompletedView(store: store)
                }
            }
            .toolbar(.hidden)
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
        case paymentCompleted(PaymentCompletedFeature)
    }

    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        var routes: IdentifiedArrayOf<Route<Screen.State>>

        public init(
            routes: IdentifiedArrayOf<Route<Screen.State>> = [
                .root(.goalList(.init()))
            ]
        ) {
            self.id = UUID()
            self.routes = routes
        }
    }

    public enum Action {
        case router(IdentifiedRouterActionOf<Screen>)
        case showMyGoal
        case coordinatorFinished
    }

    public var body: some Reducer<State, Action> {
        self.core
    }

    @ReducerBuilder<State, Action>
    var core: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .router(.routeAction(_, action: .goalList(.contentTapped(contentId)))):
                state.routes.push(
                    .goalDetail(
                        .init(
                            contentId: contentId
                        )
                    )
                )
            case .router(.routeAction(_, action: .goalDetail(.backButtonTapped))):
                state.routes.pop()
            case let .router(.routeAction(_, action: .goalDetail(.showPaymentCompleted(content)))):
                state.routes.push(
                    .paymentCompleted(.init(
                        content: .init(
                            id: content.id,
                            goalSubject: content.details.goalSubject,
                            mentor: content.details.mentor,
                            originalPrice: content.originalPrice,
                            discountedPrice: content.discountedPrice
                        )
                    ))
                )
            case .router(.routeAction(_, action: .paymentCompleted(.backButtonTapped))):
                state.routes.pop()
            case .router(.routeAction(_, action: .paymentCompleted(.startButtonTapped))):
                state.routes.popToRoot()
                return .send(.showMyGoal)
            default: return .none
            }
            return .none
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
    case let .paymentCompleted(state):
        state.id
    }
  }
}
