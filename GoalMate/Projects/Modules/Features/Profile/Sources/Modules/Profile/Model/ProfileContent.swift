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
    // 진행 중
    // 진행 완료
}

extension ProfileContent {
    static var dummy: ProfileContent {
        ProfileContent(
            name: "김골메이트",
            state: .init()
        )
    }
}
