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
                }
            }
            .toolbar(.hidden)
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
        case showMyGoal
        case coordinatorFinished
        case showLogin
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
            print("action: \(action)")
            switch action {
            case let .router(
                .routeAction(
                    id: _,
                    action: .goalList(
                        .delegate(
                            .showGoalDetail(contentId)
                        )
                    )
                )
            ):
                state.routes.presentCover(
                    .goalDetail(
                        .init(
                            contentId: contentId
                        )
                    )
                )
                return .none
            case .router(.routeAction(_, action: .goalDetail(.view(.backButtonTapped)))):
                state.routes.dismiss()
                return .none
            case .router(
                .routeAction(
                    _,
                    action: .goalDetail(.view(.loginButtonTapped))
                )
            ):
                state.routes.dismiss()
                return .send(.showLogin)
            case let .router(
                .routeAction(
                    _,
                    action: .goalDetail(.feature(.showPurchaseSheet(content)))
                )
            ):
                state.routes.presentSheet(
                    .goalPurchaseSheet(
                        .init(
                            content: .init(
                                contentId: content.id,
                                title: content.details.title,
                                mentor: content.details.mentor,
                                originalPrice: content.originalPrice,
                                discountedPrice: content.discountedPrice
                            )
                        )
                    )
                )
                return .none
            case let .router(.routeAction(_, action: .goalPurchaseSheet(.feature(
                .checkPurchaseResponse(result)
            )))):
                switch result {
                case .success(let content):
                    return Effect.routeWithDelaysIfUnsupported(state.routes, action: \.router) {
                        $0.dismiss()
                        $0.presentCover(.paymentCompleted(
                            .init(content: .init(
                                contentId: content.contentId,
                                title: content.title,
                                mentor: content.mentor,
                                originalPrice: content.originalPrice,
                                discountedPrice: content.discountedPrice
                            )))
                        )
                    }
                case let .failure(error):
                    state.routes.dismiss()
                    var message: String = "네트워크에 문제가 발생했습니다."
                    if let error = error as? NetworkError,
                       case let .statusCodeError(code) = error {
                        if code == 403 {
                            message = "참여 인원 초과 또는 무료 참여 횟수 초과"
                            print("참여 인원 초과 또는 무료 참여 횟수 초과")
                        } else if code == 404 {
                            message = "존재하지 않는 목표"
                            print("존재하지 않는 목표")
                        } else if code == 409 {
                            message = "이미 참여중인 목표"
                            print("이미 참여중인 목표")
                        }
                    }
                    if let goalDetail = state.routes.first(where: {
                        if case .goalDetail = $0.screen { return true }
                        return false
                    })?.screen as? GoalDetailFeature.State {
                        return .send(.router(.routeAction(
                            id: goalDetail.id,
                            action: .goalDetail(.feature(.showToast(message)))
                        )))
                    }
                }
                return .none
            case .router(.routeAction(_, action: .paymentCompleted(.backButtonTapped))):
                state.routes.dismiss()
                return .none
            case .router(.routeAction(_, action: .paymentCompleted(.startButtonTapped))):
                state.routes.dismissAll()
                return .send(.showMyGoal)
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
    }
  }
}
