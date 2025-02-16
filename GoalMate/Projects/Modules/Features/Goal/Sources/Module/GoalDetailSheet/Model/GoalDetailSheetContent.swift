//
//  GoalDetailSheetContent.swift
//  FeatureGoal
//
//  Created by Importants on 2/16/25.
//

import Foundation

public struct GoalDetailSheetContent: Identifiable, Equatable {
    let contentId: Int
    let title: String
    let mentor: String
    let originalPrice: Int
    let discountedPrice: Int
}

extension GoalDetailSheetContent {
    public typealias ID = Int
    public var id: Int { contentId }
}
