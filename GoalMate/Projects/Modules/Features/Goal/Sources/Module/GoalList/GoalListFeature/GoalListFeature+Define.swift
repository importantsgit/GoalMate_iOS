//
//  GoalListFeature+Define.swift
//  FeatureGoal
//
//  Created by Importants on 2/20/25.
//

import Foundation

extension GoalListFeature {
    public enum FetchGoalListResult {
        case success([GoalContent], Bool)
        case networkError
        case failed
    }
}
