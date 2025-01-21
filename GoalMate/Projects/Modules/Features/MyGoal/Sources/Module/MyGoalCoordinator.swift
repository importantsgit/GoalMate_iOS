//
//  MyGoalCoordinator.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.

import ComposableArchitecture
import FeatureCommon
import SwiftUI
import TCACoordinators

@Reducer
public struct MyGoalCoordinator {
    public init() {}
    @Reducer(state: .equatable)
    public enum Screen {
        case myGoalList(MyGoalListFeature)
        case myGoalDetail(MyGoalDetailFeature)
    }

    @ObservableState
    public struct State: Equatable {
        var routes: [Route<Screen.State>]

        public init(
            routes: [Route<Screen.State>] = [
                .root(.myGoalList(.init()), embedInNavigationView: true)
            ]
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
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

public struct MyGoalCoordinatorView: View {
    let store: StoreOf<MyGoalCoordinator>

    public init(store: StoreOf<MyGoalCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            Group {
                switch screen.case {
                case let .myGoalList(store):
                    MyGoalListView(store: store)
                case let .myGoalDetail(store):
                    MyGoalDetailView(store: store)
                }
            }
            .toolbar(.hidden)
        }
    }
}
