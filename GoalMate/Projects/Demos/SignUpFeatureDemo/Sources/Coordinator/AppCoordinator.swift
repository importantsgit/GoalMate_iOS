//
//  AppCoordinator.swift
//  DemoSignUpFeature
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture
import Data
import FeatureSignUp
import SwiftUI
import TCACoordinators

@Reducer
struct AppCoordinator {
    // MARK: - Coordinator 작성
    @Reducer(state: .equatable)
    public enum Screen {
        case main(MainFeature)
        case signUp(SignUpDemoCoordinator)
    }

    @ObservableState
    public struct State: Equatable {
        public var appDelegate: AppDelegateReducer.State
        var routes: [Route<Screen.State>]

        init(
            appDelegate: AppDelegateReducer.State = AppDelegateReducer.State(),
            routes: [Route<Screen.State>] = [.root(.main(.init()), embedInNavigationView: true)]
        ) {
            self.appDelegate = appDelegate
            self.routes = routes
        }
    }

    public enum Action {
        case appDelegate(AppDelegateReducer.Action)
        case router(IndexedRouterActionOf<Screen>)
        case didChangeScenePhase(ScenePhase)
    }

    public var body: some Reducer<State, Action> {
        self.core
            .forEachRoute(\.routes, action: \.router)
    }

    @ReducerBuilder<State, Action>
    var core: some Reducer<State, Action> {
        Scope(state: \.appDelegate, action: \.appDelegate) {
          AppDelegateReducer()
        }
        Reduce { state, action in
            switch action {
            case .router(.routeAction(
                _,
                action: .main(.delegate(.showLogin)))):
                state.routes.push(.signUp(.init()))
                return .none
            case .router(.routeAction(
                _,
                action: .main(.delegate(.showSignUp)))):
                state.routes.push(.signUp(.init()))
                return .none
            case .router(.routeAction(
                _,
                action: .signUp(.coordinatorFinished))):
                state.routes.pop()
                return .none
            case .appDelegate:
                return .none
            case .router:
                return .none
            case .didChangeScenePhase:
                return .none
            }
        }
        .dependency(\.authClient, .testValue)
    }
}

struct AppCoordinatorView: View {
    let store: StoreOf<AppCoordinator>

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .signUp(store):
                SignUpDemoCoordinatorView(store: store)
            case let .main(store):
                MainView(store: store)
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    AppCoordinatorView(
        store: Store(
            initialState: AppCoordinator.State.init(),
            reducer: {
                AppCoordinator()
            }
        )
    )
}

