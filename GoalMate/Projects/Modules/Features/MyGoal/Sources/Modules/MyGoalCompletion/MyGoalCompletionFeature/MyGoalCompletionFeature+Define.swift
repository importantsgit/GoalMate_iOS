//
//  MyGoalCompletionFeature+Define.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 2/21/25.
//

import Data
import Foundation

extension MyGoalCompletionFeature {
    public enum FetchMyGoalCompletionResult {
        case success(FetchMyGoalDetailResponseDTO.Response.MenteeGoal)
        case networkError
        case failed
    }
}
