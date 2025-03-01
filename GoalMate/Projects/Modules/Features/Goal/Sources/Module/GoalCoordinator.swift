//
//  GoalCoordinator.swift
//  Goal
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture
import Data
import FeatureCommon
import SwiftUI
import TCACoordinators
import Utils

public struct GoalCoordinatorView: View {
    let store: StoreOf<GoalCoordinator>

    public init(store: StoreOf<GoalCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            Group {
                switch screen.case {
                case let .goalList(store):
                    GoalListView(store: store)
                case let .goalDetail(store):
                    GoalDetailView(store: store)
                case let .goalPurchaseSheet(store):
                    GoalDetailSheetView(store: store)
                        .customSheet(
                            heights: [370],
                            radius: 30,
                            corners: [.topLeft, .topRight]
                        )
                case let .paymentCompleted(store):
                    PaymentCompletedView(store: store)
                case let .myGoalDetail(store):
                    MyGoalDetailView(store: store)

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
public struct GoalCoordinator {
    public init() {}
    @Reducer(state: .equatable)
    public enum Screen {
        case goalList(GoalListFeature)
        case goalDetail(GoalDetailFeature)
        case goalPurchaseSheet(GoalDetailSheetFeature)
        case paymentCompleted(PaymentCompletedFeature)
        case myGoalDetail(MyGoalDetailFeature)
        case commentDetail(CommentDetailFeature)
    }

    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        var routes: IdentifiedArrayOf<Route<Screen.State>>

        public init(
            routes: IdentifiedArrayOf<Route<Screen.State>> = [
                .root(.goalList(.init()), embedInNavigationView: true)
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
        case showMyGoal
        case showLogin
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
            case let .delegate(.showGoalDetail(contentId)):
                state.routes
                    .push(.goalDetail(.init(contentId: contentId)))
                return .send(.delegate(.setTabbarVisibility(state.routes.count == 1)))
            case let .router(.routeAction(
                _,
                action: .goalList(.delegate(.showGoalDetail(contentId))))):
                state.routes
                    .push(.goalDetail(.init(contentId: contentId))
                )
                return .send(.delegate(.setTabbarVisibility(state.routes.count == 1)))
            case .router(.routeAction(
                _,
                action: .goalDetail(.view(.backButtonTapped)))):
                state.routes.pop()
                return .send(.delegate(.setTabbarVisibility(state.routes.count == 1)))
            case .router(.routeAction(
                _,
                action: .goalDetail(.view(.loginButtonTapped)))):
                return .send(.delegate(.showLogin))
            case let .router(.routeAction(
                _,
                action: .goalDetail(.delegate(.showPurchaseSheet(content))))):
                state.routes.presentSheet(
                    .goalPurchaseSheet(
                        .init(
                            content: .init(
                                contentId: content.id,
                                title: content.title ?? "",
                                mentor: content.mentorName ?? "",
                                originalPrice: 0, // content.originalPrice,
                                discountedPrice: 0 // content.discountedPrice
                            )
                        )
                    )
                )
                return .none
            case let .router(.routeAction(
                _,
                action: .goalPurchaseSheet(.delegate(.finishPurchase(content))))):
                print("content: \(content)")
                return Effect.routeWithDelaysIfUnsupported(state.routes, action: \.router) {
                    $0.dismiss()
                    $0.push(.paymentCompleted(
                        .init(content: .init(
                            contentId: content.contentId,
                            title: content.title,
                            mentor: content.mentor,
                            originalPrice: content.originalPrice,
                            discountedPrice: content.discountedPrice,
                            menteeGoalId: content.menteeGoalId,
                            commentRoomId: content.commentRoomId
                        )))
                    )
                }
            case let .router(.routeAction(
                _,
                action: .goalPurchaseSheet(.delegate(.failed(message))))):
                guard case let .goalDetail(goalDetail) = state.routes.first?.screen
                else { return .none }
                return .send(.router(.routeAction(
                    id: goalDetail.id,
                    action: .goalDetail(.feature(.showToast(message))))))
            case .router(.routeAction(
                _,
                action: .paymentCompleted(.delegate(.closeView)))):
                state.routes.pop()
                return .none
            case let .router(.routeAction(
                _,
                action: .paymentCompleted(
                    .delegate(.showMyGoalDetail(contentId))))):
                print("contented: \(contentId)")
                return Effect.routeWithDelaysIfUnsupported(
                    state.routes, action: \.router, scheduler: .main) {
                    $0.pop()
                    $0.push(.myGoalDetail(
                        .init(menteeGoalId: contentId)))
                }
            case .router(.routeAction(
                _,
                action: .myGoalDetail(.delegate(.closeView)))):
                state.routes.popToRoot()
                return .send(.delegate(.setTabbarVisibility(state.routes.count == 1)))
            case let .router(.routeAction(
                _,
                action: .myGoalDetail(.delegate(
                    .showComment(roomId, title, endDate))))):
                state.routes.push(
                    .commentDetail(.init(
                        roomId: roomId,
                        title: title,
                        endDate: endDate)))
                return .none
            case let .router(.routeAction(
                _,
                action: .myGoalDetail(.delegate(.showGoalDetail(contentId))))):
                state.routes.push(.goalDetail(.init(contentId: contentId)))
                return .none
            case .router(.routeAction(
                _,
                action: .commentDetail(.delegate(.closeView)))):
                state.routes.pop()
                return .none
            default: return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

extension GoalCoordinator.Screen.State: Identifiable {
    public var id: UUID {
    switch self {
    case let .goalList(state):
      state.id
    case let .goalDetail(state):
      state.id
    case let .goalPurchaseSheet(state):
        state.id
    case let .paymentCompleted(state):
        state.id
    case let .myGoalDetail(state):
        state.id
    case let .commentDetail(state):
        state.id
    }
  }
}
