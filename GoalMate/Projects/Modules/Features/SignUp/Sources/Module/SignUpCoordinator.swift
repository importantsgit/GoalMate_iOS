//
//  SignUpCoordinator.swift
//  SignUp
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture
import SwiftUI
import TCACoordinators

public struct SignUpCoordinatorView: View {
    let store: StoreOf<SignUpCoordinator>

    public init(store: StoreOf<SignUpCoordinator>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            Color.white
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .signUp(store):
                    SignUpView(store: store)
                case let .termsAgreement(store):
                    TermsAgreementSheetView(store: store)
                        .customSheet(heights: [340], radius: 30, corners: [.topLeft, .topRight])
                }
            }
        }
    }
}

@Reducer
public struct SignUpCoordinator {
    public init() {}
    @Reducer(state: .equatable)
    public enum Screen {
        case signUp(SignUpFeature)
        case termsAgreement(TermsAgreementFeature)
    }
    @ObservableState
    public struct State: Equatable {
        public var id: UUID
        var routes: IdentifiedArrayOf<Route<Screen.State>>

        public init(
            routes: IdentifiedArrayOf<Route<Screen.State>> = [
                .root(.signUp(.init()), embedInNavigationView: true)
            ]
        ) {
            self.id = UUID()
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
            case let .router(
                .routeAction(
                    _,
                    action: .signUp(.feature(.checkSignUpResponse(isSuccess)))
                )):
                if isSuccess {
                    state
                        .routes
                        .presentSheet(
                            .termsAgreement(.init())
                        )
                } else {
                    break
                }
                return .none
            case .router(.routeAction(_, action: .termsAgreement(.view(.startButtonTapped)))):
                state.routes.dismiss()
                guard case let .signUp(signUp) = state.routes.first?.screen else { return .none }
                return .send(.router(.routeAction(
                    id: signUp.id,
                    action: .signUp(.feature(.showNicknameView))
                )))
            case .router(.routeAction(_, action: .signUp(.signUpSuccess(.finishButtonTapped)))):
                return .send(.coordinatorFinished)
            default: break
            }
            return .none
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

extension SignUpCoordinator.Screen.State: Identifiable {
    public var id: UUID {
    switch self {
    case let .signUp(state):
      state.id
    case let .termsAgreement(state):
      state.id
    }
  }
}
