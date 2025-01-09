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
//            case .router(.routeAction(_, action: .signUp(.signUpSucceeded))):
//                print("move to NicknameView")
//                state.routes.push(.nickname(.init()))
//            case let .router(.routeAction(_, action: .nickname(.nicknameSubmitted(nickname)))):
//                print("move to SuccessView")
//                state.routes.push(.success(.init(nickName: nickname)))
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
            }
        }
    }
}
