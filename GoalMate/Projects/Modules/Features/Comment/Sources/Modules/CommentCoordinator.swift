//
//  CommentCoordinator.swift
//  FeatureComment
//
//  Created by Importants on 2/23/25.
//

import ComposableArchitecture
import Data
import FeatureCommon
import SwiftUI
import TCACoordinators
import Utils

public struct CommentCoordinatorView: View {
    let store: StoreOf<CommentCoordinator>
    public init(store: StoreOf<CommentCoordinator>) {
        self.store = store
    }
    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            Group {
                switch screen.case {
                case let .commentList(store):
                    CommentListView(store: store)
                case let .commentDetail(store):
                    CommentDetailView(store: store)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
        }
    }
}

@Reducer
public struct CommentCoordinator {
    public init() {}
    @Reducer(state: .equatable)
    public enum Screen {
        case commentList(CommentListFeature)
        case commentDetail(CommentDetailFeature)
    }
    @ObservableState
    public struct State: Equatable, Identifiable {
        public let id: UUID
        var routes: IdentifiedArrayOf<Route<Screen.State>>
        public init(
            routes: IdentifiedArrayOf<Route<Screen.State>> = [
                .root(.commentList(.init()), embedInNavigationView: true)
            ]
        ) {
            self.id = UUID()
            self.routes = routes
        }
    }
    public enum Action {
        case delegate(DelegateAction)
        case router(IdentifiedRouterActionOf<Screen>)
    }
    public enum DelegateAction {
        case showGoalList
        case setTabbarVisibility(Bool)
    }
    public var body: some Reducer<State, Action> {
        self.core
//            .dependency(\.authClient, .previewValue)
//            .dependency(\.menteeClient, .previewValue)
    }
    @ReducerBuilder<State, Action>
    var core: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(
                _,
                action: .commentList(.delegate(.showGoalList)))):
                return .send(.delegate(.showGoalList))
            case let .router(.routeAction(
                _,
                action: .commentList(.delegate(
                    .showCommentDetail(roomId, title, startDate))))):
                state.routes.push(.commentDetail(.init(
                    roomId: roomId, title: title, startDate: startDate)))
                return .send(.delegate(.setTabbarVisibility(state.routes.count == 1)))
            case .router(.routeAction(
                _,
                action: .commentDetail(.delegate(.closeView)))):
                state.routes.pop()
                return .send(.delegate(.setTabbarVisibility(state.routes.count == 1)))
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

extension CommentCoordinator.Screen.State: Identifiable {
    public var id: UUID {
        switch self {
        case let .commentList(state):
            state.id
        case let .commentDetail(state):
            state.id
        }
    }
}
