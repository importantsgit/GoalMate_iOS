//
//  ProfileCoordinator.swift
//  FeatureProfile
//
//  Created by 이재훈 on 1/21/25.

import ComposableArchitecture
import FeatureCommon
import SwiftUI
import TCACoordinators

@Reducer
public struct ProfileCoordinator {
    public init() {}
    @Reducer(state: .equatable)
    public enum Screen {
        case profile(ProfileFeature)
        case withdrawal(WithdrawalFeature)
    }

    @ObservableState
    public struct State: Equatable {
        var routes: [Route<Screen.State>]

        public init(
            routes: [Route<Screen.State>] = [
                .root(.profile(.init()))
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
            switch action {
            case .router(.routeAction(_, action: .profile(.view(.withdrawalButtonTapped)))):
                state.routes.push(
                    .withdrawal(
                        .init()
                    )
                )
            case .router(.routeAction(_, action: .withdrawal(.backButtonTapped))):
                state.routes.popToRoot()
            default: return .none
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

public struct ProfileCoordinatorView: View {
    let store: StoreOf<ProfileCoordinator>

    public init(store: StoreOf<ProfileCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            Group {
                switch screen.case {
                case let .profile(store):
                    ProfileView(store: store)
                case let .withdrawal(store):
                    WithdrawalView(store: store)
                }
            }
            .toolbar(.hidden)
        }
    }
}
