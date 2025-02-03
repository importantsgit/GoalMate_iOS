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
        var routes: [Route<Screen.State>]

        public init(
            routes: [Route<Screen.State>] = [.root(.goalList(.init()), embedInNavigationView: true)]
        ) {
            self.routes = routes
        }
    }

    public enum Action {
        case router(IndexedRouterActionOf<Screen>)
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
                state.routes.presentCover(
                    .goalDetail(
                        .init(
                            contentId: contentId
                        )
                    )
                )
            case .router(.routeAction(_, action: .goalDetail(.backButtonTapped))):
                state.routes.dismiss()
            case let .router(.routeAction(_, action: .goalDetail(.showPaymentCompleted(content)))):
                state.routes.presentCover(
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
                state.routes.dismiss()
            case .router(.routeAction(_, action: .paymentCompleted(.startButtonTapped))):
                state.routes.dismissAll()
                return .send(.showMyGoal)
            default: return .none
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

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
