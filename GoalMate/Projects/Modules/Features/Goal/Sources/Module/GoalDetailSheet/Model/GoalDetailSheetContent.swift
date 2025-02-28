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
    var menteeGoalId: Int?
    var commentRoomId: Int?

    init(
        contentId: Int,
        title: String,
        mentor: String,
        originalPrice: Int,
        discountedPrice: Int,
        menteeGoalId: Int? = nil,
        commentRoomId: Int? = nil
    ) {
        self.contentId = contentId
        self.title = title
        self.mentor = mentor
        self.originalPrice = originalPrice
        self.discountedPrice = discountedPrice
        self.menteeGoalId = menteeGoalId
        self.commentRoomId = commentRoomId
    }
    mutating func setJoinGoalInfo(
        menteeGoalId: Int,
        commentRoomId: Int) {
            self.menteeGoalId = menteeGoalId
            self.commentRoomId = commentRoomId
    }
}

extension GoalDetailSheetContent {
    public typealias ID = Int
    public var id: Int { contentId }
}
