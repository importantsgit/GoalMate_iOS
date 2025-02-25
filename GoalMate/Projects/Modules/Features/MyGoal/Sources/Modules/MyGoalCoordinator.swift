//
//  MyGoalCoordinator.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.

import ComposableArchitecture
import Data
import FeatureCommon
import SwiftUI
import TCACoordinators

public struct MyGoalCoordinatorView: View {
    let store: StoreOf<MyGoalCoordinator>

    public init(store: StoreOf<MyGoalCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            Group {
                switch screen.case {
                case let .myGoalList(store):
                    MyGoalListView(store: store)
                case let .myGoalDetail(store):
                    MyGoalDetailView(store: store)
                case let .myGoalCompletion(store):
                    MyGoalCompletionView(store: store)
                case let .goalDetail(store):
                    GoalDetailView(store: store)
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
public struct MyGoalCoordinator {
    public init() {}
    @Reducer(state: .equatable)
    public enum Screen {
        case myGoalList(MyGoalListFeature)
        case myGoalDetail(MyGoalDetailFeature)
        case myGoalCompletion(MyGoalCompletionFeature)
        case goalDetail(GoalDetailFeature)
        case commentDetail(CommentDetailFeature)
    }

    @ObservableState
    public struct State: Equatable, Identifiable {
        public let id: UUID
        var routes: IdentifiedArrayOf<Route<Screen.State>>

        public init(
            routes: IdentifiedArrayOf<Route<Screen.State>> = [
                .root(.myGoalList(.init()), embedInNavigationView: true)
            ]
        ) {
            self.id = UUID()
            self.routes = routes
        }
    }

    public enum Action {
        case router(IdentifiedRouterActionOf<Screen>)
        case delegate(DelegateAction)
    }
    public enum DelegateAction {
        case setTabbarVisibility(Bool)
        case showGoalList
        case showGoalDetail(Int)
    }

    public var body: some Reducer<State, Action> {
        self.core
//            .dependency(\.authClient, .previewValue)
//            .dependency(\.goalClient, .previewValue)
//            .dependency(\.menteeClient, .previewValue)
    }

    @ReducerBuilder<State, Action>
    var core: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(
                _,
                action: .myGoalList(.delegate(.showGoalList)))):
                return .send(.delegate(.showGoalList))
            case let .router(.routeAction(
                _,
                action: .myGoalList(.delegate(.restartGoal(contentId))))):
                return .send(.delegate(.showGoalDetail(contentId)))
            case let .router(.routeAction(
                _,
                action: .myGoalList(.delegate(.showMyGoalDetail(contentId))))):
                state.routes.push(.myGoalDetail(.init(menteeGoalId: contentId)))
                return .send(.delegate(.setTabbarVisibility(state.routes.count == 1)))
            case let .router(.routeAction(
                _,
                action: .myGoalList(.delegate(.showMyGoalCompletion(contentId))))):
                state.routes.push(.myGoalCompletion(.init(contentId: contentId)))
                return .send(.delegate(.setTabbarVisibility(state.routes.count == 1)))
            case let .router(.routeAction(
                _,
                action: .myGoalDetail(.delegate(
                    .showComment(commentRoomId, title, startDate))))):
                state.routes.push(.commentDetail(
                    .init(roomId: commentRoomId, title: title, startDate: startDate)))
                return .none
            case .router(.routeAction(
                _,
                action: .myGoalDetail(.delegate(.closeView)))):
                state.routes.pop()
                return .send(.delegate(.setTabbarVisibility(state.routes.count == 1)))
            case let .router(.routeAction(
                _,
                action: .myGoalDetail(.delegate(.showGoalDetail(contentId))))):
                state.routes.push(
                    .goalDetail(.init(
                        contentId: contentId, isShowButton: false)))
                return .none
            case .router(.routeAction(
                _,
                action: .goalDetail(.delegate(.closeView)))):
                state.routes.pop()
                return .send(.delegate(.setTabbarVisibility(state.routes.count == 1)))
            case .router(.routeAction(
                _,
                action: .myGoalCompletion(.delegate(.closeView)))):
                state.routes.pop()
                return .send(.delegate(.setTabbarVisibility(state.routes.count == 1)))
            case let .router(.routeAction(
                _,
                action: .myGoalCompletion(
                    .delegate(.showComment(commentRoomId, title, startDate))))):
                state.routes.push(.commentDetail(
                    .init(roomId: commentRoomId, title: title, startDate: startDate)))
                return .none
            case .router(.routeAction(
                _,
                action: .myGoalCompletion(.delegate(.showGoalList)))):
                // showGoalList
                state.routes.popToRoot()
                return .send(.delegate(.showGoalList))
            case let .router(.routeAction(
                _,
                action: .myGoalCompletion(.delegate(.showGoalDetail(contentId))))):
                state.routes.push(
                    .goalDetail(.init(
                        contentId: contentId, isShowButton: false)))
                return .none
            case .router(.routeAction(
                _,
                action: .commentDetail(.delegate(.closeView)))):
                state.routes.pop()
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

extension MyGoalCoordinator.Screen.State: Identifiable {
    public var id: UUID {
    switch self {
    case let .myGoalList(state):
        state.id
    case let .myGoalDetail(state):
        state.id
    case let .myGoalCompletion(state):
        state.id
    case let .goalDetail(state):
        state.id
    case let .commentDetail(state):
        state.id
    }
  }
}
