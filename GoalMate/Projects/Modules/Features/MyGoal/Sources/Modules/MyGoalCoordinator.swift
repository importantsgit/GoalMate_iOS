//
//  MyGoalCoordinator.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.

import ComposableArchitecture
import Data
import FeatureCommon
import SwiftUI
import TCACoordinators

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

@Reducer
public struct MyGoalCoordinator {
    public init() {}
    @Reducer(state: .equatable)
    public enum Screen {
        case myGoalList(MyGoalListFeature)
        case myGoalDetail(MyGoalDetailFeature)
    }

    @ObservableState
    public struct State: Equatable, Identifiable {
        public let id: UUID
        var routes: IdentifiedArrayOf<Route<Screen.State>>

        public init(
            routes: IdentifiedArrayOf<Route<Screen.State>> = [
                .root(.myGoalList(.init()))
            ]
        ) {
            self.id = UUID()
            self.routes = routes
        }
    }

    public enum Action {
        case router(IdentifiedRouterActionOf<Screen>)
        case showMyGoalDetail(Int)
        case coordinatorFinished
    }

    public var body: some Reducer<State, Action> {
        self.core
    }

    @ReducerBuilder<State, Action>
    var core: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .router(.routeAction(_, action: .myGoalList(.showMyGoalDetail(data)))):
                state.routes.push(.myGoalDetail(.init(
                    goalId: data.id,
                    startDate: data.startDate,
                    endDate: data.endDate
                )))
            case let .router(.routeAction(_, action: .myGoalList(.showGoalDetail(id)))):
                state.routes.pop()
                return .send(.showMyGoalDetail(id))
            case .router(.routeAction(_, action: .myGoalDetail(.backButtonTapped))):
                state.routes.popToRoot()
            default: return .none
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

extension MyGoalCoordinator.Screen.State: Identifiable {
    public var id: UUID {
    switch self {
    case let .myGoalList(state):
        state.id
    case let .myGoalDetail(state):
        state.id
    }
  }
}
