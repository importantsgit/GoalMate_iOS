//
//  AppCoordinator.swift
//  DemoSignUpFeature
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture
import FeatureHome
import FeatureIntro
import FeatureSignUp
import SwiftUI
import TCACoordinators

struct AppCoordinatorView: View {
    let store: StoreOf<AppCoordinator>
    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .intro(store):
                IntroCoordinatorView(store: store)
            case let .signUp(store):
                SignUpCoordinatorView(store: store)
            case let .tab(store):
                TabCoordinatorView(store: store)
            }
        }
    }
}

@Reducer
struct AppCoordinator {
    @Reducer(state: .equatable)
    public enum Screen {
        case intro(IntroCoordinator)
        case signUp(SignUpCoordinator)
        case tab(TabCoordinator)
    }
    @ObservableState
    public struct State: Equatable {
        var id: UUID
        var appDelegate: AppDelegateReducer.State
        var routes: IdentifiedArrayOf<Route<Screen.State>>
        init(
            appDelegate: AppDelegateReducer.State = AppDelegateReducer.State(),
            routes: IdentifiedArrayOf<Route<Screen.State>> = [
                .root(.intro(.init()), embedInNavigationView: true)
            ]
        ) {
            self.id = UUID()
            self.appDelegate = appDelegate
            self.routes = routes
        }
    }
    public enum Action {
        case appDelegate(AppDelegateReducer.Action)
        case router(IdentifiedRouterActionOf<Screen>)
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
            case .appDelegate:
                return .none
            case .router(.routeAction(
                    _,
                    action: .intro(.coordinatorFinished))):
                state.routes = [
                    .root(.tab(.init()), embedInNavigationView: true)
                ]
                return .none
            case .router(.routeAction(
                _,
                action: .tab(.coordinator(.showLogin)))):
                state.routes.push(.signUp(.init()))
                return .none
            case .router(.routeAction(
                    _,
                    action: .signUp(.coordinatorFinished))):
                state.routes.pop()
                return .none
            case .didChangeScenePhase:
                return .none
            default: return .none
            }
        }
    }
}

extension AppCoordinator.Screen.State: Identifiable {
    public var id: UUID {
        switch self {
        case let .signUp(state):
            state.id
        case let .tab(state):
            state.id
        case let .intro(state):
            state.id
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
