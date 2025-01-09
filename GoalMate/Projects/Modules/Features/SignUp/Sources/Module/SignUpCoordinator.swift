//
//  SignUpCoordinator.swift
//  SignUp
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

@Reducer
public struct SignUpCoordinator {
    public init() {}
    @Reducer(state: .equatable)
    public enum Screen {
        case signUp(SignUpFeature)
        case nickname(NicknameFeature)
        case success(SignUpSuccessFeature)
    }

    @ObservableState
    public struct State: Equatable {
        var routes: [Route<Screen.State>]

        public init(
            routes: [Route<Screen.State>] = [.root(.signUp(.init()), embedInNavigationView: true)]
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
            case .router(.routeAction(_, action: .signUp(.signUpSucceeded))):
                print("move to NicknameView")
                state.routes.push(.nickname(.init()))
            case let .router(.routeAction(_, action: .nickname(.nicknameSubmitted(nickname)))):
                print("move to SuccessView")
                state.routes.push(.success(.init(nickName: nickname)))
            default: break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

public struct SignUpCoordinatorView: View {
    let store: StoreOf<SignUpCoordinator>

    public init(store: StoreOf<SignUpCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .signUp(store):
                SignUpView(store: store)
                    .toolbar(.hidden)
            case let .nickname(store):
                NicknameView(store: store)
                    .toolbar(.hidden)
            case let .success(store):
                SignUpSuccessView(store: store)
                    .toolbar(.hidden)
            }
        }
    }
}
