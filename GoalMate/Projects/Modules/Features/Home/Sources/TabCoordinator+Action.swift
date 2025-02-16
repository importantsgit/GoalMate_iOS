//
//  TabCoordinator+Action.swift
//  FeatureHome
//
//  Created by Importants on 2/14/25.
//

import ComposableArchitecture
import Data
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
        case .showMyGoal:
            state.selectedTab = .myGoal
            return .none
        default: return .none
        }
    }
    func reduce(into state: inout State, action: MyGoalCoordinator.Action) -> Effect<Action> {
        switch action {
        case let .showMyGoalDetail(id):
            state.selectedTab = .goal
            return .none
        default: return .none
        }
    }
    func reduce(into state: inout State, action: ProfileCoordinator.Action) -> Effect<Action> {
        switch action {
        default: return .none
        }
    }
}
