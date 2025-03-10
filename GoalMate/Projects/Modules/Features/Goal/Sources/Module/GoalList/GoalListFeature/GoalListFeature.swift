//
//  GoalListFeature.swift
//  FeatureGoal
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture
import Data
import Dependencies
import FeatureCommon
import Foundation

@Reducer
public struct GoalListFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        var isLoading: Bool
        var isRefreshing: Bool
        var isScrollFetching: Bool
        var didFailToLoad: Bool
        var goalContents: IdentifiedArrayOf<Goal>
        var pagingationState: PaginationState
        public init(
            isLoading: Bool = false
        ) {
            self.id = UUID()
            self.isLoading = true
            self.isRefreshing = false
            self.isScrollFetching = false
            self.didFailToLoad = false
            self.goalContents = []
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
        case refreshGoalList
        case contentTapped(Int)
        case retryButtonTapped
    }
    public enum FeatureAction {
        case fetchGoals
        case checkFetchGoalListResponse(FetchGoalListResult)
    }
    public enum DelegateAction {
        case showGoalDetail(Int)
    }
    @Dependency(\.goalClient) var goalClient
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
