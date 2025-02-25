//
//  TabCoordinator.swift
//  FeatureHome
//
//  Created by Importants on 1/20/25.
//

import ComposableArchitecture
import FeatureComment
import FeatureCommon
import FeatureGoal
import FeatureMyGoal
import FeatureProfile
import SwiftUI
import TCACoordinators

@Reducer
public struct TabCoordinator {
    public init() {}
    public enum Tab: Equatable {
        case goal
        case myGoal
        case comment
        case profile
    }
    @ObservableState
    public struct State: Equatable {
        public var id: UUID
        public var selectedTab: Tab
        public var isTabVisible: Bool
        public var hasRemainingTodos: Bool
        public var goal: GoalCoordinator.State
        public var myGoal: MyGoalCoordinator.State
        public var comment: CommentCoordinator.State
        public var profile: ProfileCoordinator.State
        public init(
            selectedTab: Tab = .goal,
            goal: GoalCoordinator.State = .init(),
            myGoal: MyGoalCoordinator.State = .init(),
            comment: CommentCoordinator.State = .init(),
            profile: ProfileCoordinator.State = .init()
        ) {
            self.id = UUID()
            self.selectedTab = selectedTab
            self.goal = goal
            self.myGoal = myGoal
            self.comment = comment
            self.profile = profile
            self.isTabVisible = true
            self.hasRemainingTodos = false
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case feature(FeatureAction)
        case coordinator(CoordinatorAction)
        case goal(GoalCoordinator.Action)
        case myGoal(MyGoalCoordinator.Action)
        case profile(ProfileCoordinator.Action)
        case comment(CommentCoordinator.Action)
        case binding(BindingAction<State>)
        case remainingTodosNoticeTapped(Bool)
    }
    public enum ViewCyclingAction {
        case onAppear
    }
    public enum CoordinatorAction {
        case showLogin
    }
    public enum FeatureAction {
        case hideRemainingTodoNotice
        case checkRemainingTodo
        case checkRemainingTodoResponse(Bool)
    }
    @Dependency(\.menteeClient) var menteeClient
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Scope(state: \.goal, action: \.goal) {
            GoalCoordinator()
        }
        Scope(state: \.myGoal, action: \.myGoal) {
            MyGoalCoordinator()
        }
        Scope(state: \.comment, action: \.comment) {
            CommentCoordinator()
        }
        Scope(state: \.profile, action: \.profile) {
            ProfileCoordinator()
        }
        Reduce { state, action in
            switch action {
            case let .viewCycling(action):
                return reduce(into: &state, action: action)
            case let .feature(action):
                return reduce(into: &state, action: action)
            case let .coordinator(action):
                return reduce(into: &state, action: action)
            case let .goal(action):
                return reduce(into: &state, action: action)
            case let .myGoal(action):
                return reduce(into: &state, action: action)
            case let .comment(action):
                return reduce(into: &state, action: action)
            case let .profile(action):
                return reduce(into: &state, action: action)
            case .remainingTodosNoticeTapped:
                state.hasRemainingTodos = false
                return .send(.feature(.hideRemainingTodoNotice))
            case .binding:
                return .none
            }
        }
    }
}
