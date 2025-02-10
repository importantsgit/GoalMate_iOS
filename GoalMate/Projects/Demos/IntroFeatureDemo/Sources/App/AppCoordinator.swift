//
//  AppCoordinator.swift
//  DemoSignUpFeature
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture
import FeatureIntro
import SwiftUI
import TCACoordinators

@Reducer
struct AppCoordinator {
    // MARK: - Coordinator 작성
    @Reducer(state: .equatable)
    public enum Screen {
        case intro(IntroCoordinator)
    }

    @ObservableState
    public struct State: Equatable {
        public var appDelegate: AppDelegateReducer.State
        var routes: [Route<Screen.State>]

        init(
            appDelegate: AppDelegateReducer.State = AppDelegateReducer.State(),
            routes: [Route<Screen.State>] = [.root(.intro(.init()))]
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

struct AppCoordinatorView: View {
    let store: StoreOf<AppCoordinator>

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .intro(store):
                IntroCoordinatorView(store: store)
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

