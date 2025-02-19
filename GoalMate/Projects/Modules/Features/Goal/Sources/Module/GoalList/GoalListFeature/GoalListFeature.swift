//
//  GoalListFeature.swift
//  FeatureGoal
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture
import Data
import Dependencies
import Foundation

@Reducer
public struct GoalListFeature {
    public enum FetchError: Error {
        case networkError
        case emptyData
    }
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        var isLoading: Bool
        var didFailToLoad: Bool
        var goalContents: [GoalContent]
        
        var totalCount: Int
        var currentPage: Int
        var hasMorePages: Bool
        public init(
            isLoading: Bool = false,
            goalContents: [GoalContent] = []
        ) {
            self.id = UUID()
            self.isLoading = true
            self.didFailToLoad = false
            self.goalContents = goalContents
            self.hasMorePages = true
            self.currentPage = 1
            self.totalCount = 0
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
        BindingReducer()
    }
}
