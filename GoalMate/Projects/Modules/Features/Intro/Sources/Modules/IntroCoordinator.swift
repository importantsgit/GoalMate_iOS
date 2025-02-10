//
//  IntroCoordinator.swift
//  FeatureIntro
//
//  Created by Importants on 2/10/25.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct IntroCoordinatorView: View {
    let store: StoreOf<IntroCoordinator>

    public init(store: StoreOf<IntroCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .introStep(store):
                IntroStepView(store: store)
            }
        }
    }
}

@Reducer
public struct IntroCoordinator {
    public init() {}
    @Reducer(state: .equatable)
    public enum Screen {
        case introStep(IntroStepFeature)
    }
    @ObservableState
    public struct State: Equatable {
        var routes: IdentifiedArrayOf<Route<Screen.State>>
        public init(
            routes: IdentifiedArrayOf<Route<Screen.State>> = [
                .root(.introStep(.init()), embedInNavigationView: true)
            ]
        ) {
            self.routes = routes
        }
    }
    public enum Action {
        case router(IdentifiedRouterActionOf<Screen>)
        case coordinatorFinished
    }
    public var body: some Reducer<State, Action> {
        self.core
    }
    @ReducerBuilder<State, Action>
    var core: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            default: break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

extension IntroCoordinator.Screen.State: Identifiable {
    public var id: UUID {
    switch self {
    case let .introStep(state):
      state.id
    }
  }
}
