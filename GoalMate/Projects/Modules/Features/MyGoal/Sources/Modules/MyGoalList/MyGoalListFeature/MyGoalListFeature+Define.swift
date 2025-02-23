//
//  MyGoalListFeature+Define.swift
//  FeatureMyGoal
//
//  Created by Importants on 2/19/25.
//

import Foundation

extension MyGoalListFeature {
    public enum ButtonType {
        case showGoalCompletion(Int)
        case showGoalDetail(Int)
        case showGoalRestart(Int)
    }
    public enum FetchMyGoalsResult {
        case success([MyGoalContent], Bool)
        case networkError
        case failed
    }
}
