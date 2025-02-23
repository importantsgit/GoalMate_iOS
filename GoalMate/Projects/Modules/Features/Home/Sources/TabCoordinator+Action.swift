//
//  TabCoordinator+Action.swift
//  FeatureHome
//
//  Created by Importants on 2/14/25.
//

import ComposableArchitecture
import Data
import FeatureComment
import FeatureGoal
import FeatureMyGoal
import FeatureProfile

extension TabCoordinator {
    func reduce(into state: inout State, action: CoordinatorAction) -> Effect<Action> {
        switch action {
        case .showLogin:
            return .none
        }
    }
    func reduce(into state: inout State, action: GoalCoordinator.Action) -> Effect<Action> {
        switch action {
        case .delegate(.showMyGoal):
            state.selectedTab = .myGoal
            state.isTabVisible = true
            return .none
        case .delegate(.showLogin):
            return .send(.coordinator(.showLogin))
        case let .delegate(.setTabbarVisibility(isShow)):
            state.isTabVisible = isShow
            return .none
        default:
            return .none
        }
    }
    func reduce(into state: inout State, action: MyGoalCoordinator.Action) -> Effect<Action> {
        switch action {
        case .delegate(.showGoalList):
            state.isTabVisible = true
            state.selectedTab = .goal
            return .none
        case let .delegate(.setTabbarVisibility(isShow)):
            state.isTabVisible = isShow
            return .none
        default: return .none
        }
    }
    func reduce(into state: inout State, action: CommentCoordinator.Action) -> Effect<Action> {
        switch action {
        case let .delegate(.setTabbarVisibility(isShow)):
            state.isTabVisible = isShow
            return .none
        default: return .none
        }
    }
    func reduce(into state: inout State, action: ProfileCoordinator.Action) -> Effect<Action> {
        switch action {
        case .delegate(.showLogin):
            return .send(.coordinator(.showLogin))
        case .delegate(.showMyGoalList):
            state.selectedTab = .myGoal
            return .none
        case .delegate(.showGoalList):
            state.selectedTab = .goal
            return .none
        case let .delegate(.setTabbarVisibility(isShow)):
            state.isTabVisible = isShow
            return .none
        default: return .none
        }
    }
}
