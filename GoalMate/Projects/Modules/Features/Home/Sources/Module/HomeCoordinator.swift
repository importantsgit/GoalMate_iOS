//
//  HomeCoordinator.swift
//  SignUp
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

@Reducer
public struct HomeCoordinator {
    public init() {}
    @Reducer(state: .equatable)
    public enum Screen {
        case home(HomeFeature)
        case goalDetail(GoalDetailFeature)
    }

    @ObservableState
    public struct State: Equatable {
        var routes: [Route<Screen.State>]

        public init(
            routes: [Route<Screen.State>] = [.root(.home(.init()), embedInNavigationView: true)]
        ) {
            self.routes = routes
        }
    }

    public enum Action {
        case router(IndexedRouterActionOf<Screen>)
        case coordinatorFinished
    }

    public var body: some Reducer<State, Action> {
        self.core
    }

    @ReducerBuilder<State, Action>
    var core: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .router(.routeAction(_, action: .home(.contentTapped(contentId)))):
                state.routes.push(.goalDetail(.init(contentId: contentId)))
                return .none
            case .router(.routeAction(_, action: .goalDetail(.backButtonTapped))):
                state.routes.pop()
                return .none
            default: return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

public struct HomeCoordinatorView: View {
    let store: StoreOf<HomeCoordinator>

    public init(store: StoreOf<HomeCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .home(store):
                HomeView(store: store)
                    .toolbar(.hidden)
            case let .goalDetail(store):
                GoalDetailView(store: store)
                    .toolbar(.hidden)
            }
        }
    }
}
