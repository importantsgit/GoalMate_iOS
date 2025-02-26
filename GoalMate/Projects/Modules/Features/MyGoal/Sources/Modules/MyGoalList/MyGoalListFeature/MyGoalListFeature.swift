//
//  MyGoalListFeature.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import ComposableArchitecture
import Data
import FeatureCommon
import Foundation

@Reducer
public struct MyGoalListFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        var isLogin: Bool
        var isLoading: Bool
        var isScrollFetching: Bool
        var didFailToLoad: Bool
        var pagingationState: PaginationState
        var myGoalList: IdentifiedArrayOf<MenteeGoal>
        public init(
            myGoalList: IdentifiedArrayOf<MenteeGoal> = []
        ) {
            self.id = UUID()
            self.isLogin = true
            self.isLoading = true
            self.isScrollFetching = false
            self.didFailToLoad = false
            self.myGoalList = myGoalList
            self.pagingationState = .init()
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {
        case onAppear
    }
    public enum ViewAction {
        case onLoadMore
        case showMoreButtonTapped
        case buttonTapped(ButtonType)
        case retryButtonTapped
    }
    public enum FeatureAction {
        case fetchMyGoals
        case checkFetchMyGoalResponse(FetchMyGoalsResult)
        case loginFailed
    }
    public enum DelegateAction {
        case showGoalList
        case showMyGoalCompletion(Int)
        case showMyGoalDetail(Int)
        case restartGoal(Int)
    }
    @Dependency(\.authClient) var authClient
    @Dependency(\.menteeClient) var menteeClient
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .viewCycling(action):
                return reduce(into: &state, action: action)
            case let .view(action):
                return reduce(into: &state, action: action)
            case let .feature(action):
                return reduce(into: &state, action: action)
            case let .delegate(action):
                return reduce(into: &state, action: action)
            case .binding:
                return .none
            }
        }
    }
}
