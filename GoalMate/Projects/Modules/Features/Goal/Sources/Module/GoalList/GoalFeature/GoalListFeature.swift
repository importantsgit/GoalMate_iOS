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
        var currentPage = 1
        var isLoading: Bool
        var goalContents: [GoalContent]
        var hasNextPage: Bool = true
        public init(
            isLoading: Bool = false,
            goalContents: [GoalContent] = []
        ) {
            self.id = UUID()
            self.isLoading = false
            self.goalContents = goalContents
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {
        case onAppear
    }
    public enum ViewAction {
        case onLoadMore
        case contentTapped(Int)
    }
    public enum FeatureAction {
        case fetchGoalListResponse(Result<([GoalContent], Bool), FetchError>)
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
            case .binding:
                return .none

            }
        }
        BindingReducer()
    }
}
