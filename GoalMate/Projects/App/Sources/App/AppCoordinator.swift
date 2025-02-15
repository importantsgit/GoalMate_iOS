//
//  AppCoordinator.swift
//  DemoSignUpFeature
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture
import FeatureSignUp
import FeatureHome
import SwiftUI
import TCACoordinators

struct AppCoordinatorView: View {
    let store: StoreOf<AppCoordinator>

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
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
                .root(.tab(.init()), embedInNavigationView: true)
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
            case .router:
                return .none
            case .didChangeScenePhase:
                return .none
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

