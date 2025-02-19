//
//  MyGoalListFeature+Define.swift
//  FeatureMyGoal
//
//  Created by Importants on 2/19/25.
//

import Foundation

extension MyGoalListFeature {
    public enum ButtonType {
        case showDetail(Int)
        case restart(Int)
    }
    public enum FetchMyGoalsResult {
        case success([MyGoalContent])
        case networkError
        case failed
    }
}
