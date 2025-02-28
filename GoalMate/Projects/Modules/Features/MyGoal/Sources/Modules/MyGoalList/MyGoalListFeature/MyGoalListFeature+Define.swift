//
//  MyGoalListFeature+Define.swift
//  FeatureMyGoal
//
//  Created by Importants on 2/19/25.
//

import Data
import Foundation

extension MyGoalListFeature {
    public enum PublisherID {
        case throttle
    }

    public enum ButtonType {
        case showGoalCompletion(Int)
        case showGoalDetail(Int)
        case showGoalRestart(Int)
    }
    public enum FetchMyGoalsResult {
        case success([MenteeGoal], Bool)
        case networkError
        case failed
    }
}
