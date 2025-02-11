//
//  ProfileContent.swift
//  FeatureProfile
//
//  Created by 이재훈 on 1/22/25.
//

import Foundation

public struct ProfileContent: Identifiable, Equatable {
    public var id: String { name }
    var name: String
    var state: GoalCountState
    init(
        name: String,
        state: GoalCountState
    ) {
        self.name = name
        self.state = state
    }
    public static func == (lhs: ProfileContent, rhs: ProfileContent) -> Bool {
        return lhs.id == rhs.id
    }
}

public struct GoalCountState {
    let inProgressCount: Int  // 진행 중인 목표 수
    let completedCount: Int   // 완료된 목표 수
    public init(
        inProgressCount: Int,
        completedCount: Int
    ) {
        self.inProgressCount = inProgressCount
        self.completedCount = completedCount
    }
}

extension ProfileContent {
    static var dummy: ProfileContent {
        ProfileContent(
            name: "김골메이트",
            state: .init(
                inProgressCount: 10,
                completedCount: 2
            )
        )
    }
}
