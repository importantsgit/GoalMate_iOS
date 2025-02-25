//
//  MyGoalListFeature+Define.swift
//  FeatureMyGoal
//
//  Created by Importants on 2/19/25.
//

import Data
import Foundation

extension MyGoalListFeature {
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
    public struct PaginationState: Equatable {
        var totalCount: Int
        var currentPage: Int
        var hasMorePages: Bool
        init(
            totalCount: Int = 0,
            currentPage: Int = 1,
            hasMorePages: Bool = true
        ) {
            self.totalCount = totalCount
            self.currentPage = currentPage
            self.hasMorePages = hasMorePages
        }
    }
}
