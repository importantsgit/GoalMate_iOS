//
//  ProfileCoordinator.swift
//  FeatureProfile
//
//  Created by 이재훈 on 1/21/25.

import ComposableArchitecture
import FeatureCommon
import SwiftUI
import TCACoordinators

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
                case let .nicknameEdit(store):
                    NicknameEditView(store: store)
                        .customSheet(
                            heights: [280],
                            radius: 30,
                            corners: [.topLeft, .topRight]
                        )
                }
            }
            .toolbar(.hidden)
        }
    }
}

@Reducer
public struct ProfileCoordinator {
    public init() {}
    @Reducer(state: .equatable)
    public enum Screen {
        case profile(ProfileFeature)
        case nicknameEdit(NicknameEditFeature)
        case withdrawal(WithdrawalFeature)
    }

    @ObservableState
    public struct State: Equatable {
        var routes: IdentifiedArrayOf<Route<Screen.State>>

        public init(
            routes: IdentifiedArrayOf<Route<Screen.State>> = [
                .root(.profile(.init()))
            ]
        ) {
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
                    action: .profile(
                        .feature(.showNicknameEdit(nickname))
                    )
                )
            ):
                state.routes.presentSheet(
                    .nicknameEdit(.init(nickname: nickname))
                )
                return .none
            case let .router(.routeAction(
                _,
                action: .nicknameEdit(.feature(.nicknameSubmitted(result))))
            ):
                if case let .success(nickname) = result {
                    guard let profileRoute = state.routes.first(where: {
                              if case .profile = $0.screen { return true }
                              return false
                          }),
                          case let .profile(profileState) = profileRoute.screen
                    else {
                        return .none
                    }
                    return .send(.router(.routeAction(
                        id: profileState.id,
                        action: .profile(.view(.setNickname(nickname)))
                    )))
                }
                return .none
            case .router(.routeAction(
                _,
                action: .nicknameEdit(.feature(.nicknameEditCompleted))
            )):
                state.routes.dismiss()
                return .none
            case .router(.routeAction(_, action: .profile(.view(.withdrawalButtonTapped)))):
                state.routes.presentCover(
                    .withdrawal(
                        .init()
                    )
                )
                return .none
            case .router(.routeAction(_, action: .withdrawal(.view(.backButtonTapped)))):
                state.routes.dismiss()
                return .none
            default: return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

extension ProfileCoordinator.Screen.State: Identifiable {
    public var id: UUID {
    switch self {
    case let .profile(state):
      state.id
    case let .withdrawal(state):
      state.id
    case let .nicknameEdit(state):
        state.id
    }
  }
}
