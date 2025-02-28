//
//  GoalListFeature+Define.swift
//  FeatureGoal
//
//  Created by Importants on 2/20/25.
//

import Data
import Foundation

extension GoalListFeature {
    public enum PublisherID {
        case throttle
    }
    public enum FetchGoalListResult {
        case success([Goal], Bool)
        case networkError
        case failed
    }
}
