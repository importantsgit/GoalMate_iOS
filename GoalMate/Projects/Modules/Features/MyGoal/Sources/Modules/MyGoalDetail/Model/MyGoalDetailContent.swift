//
//  MyGoalDetailContent.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/22/25.
//

import Foundation

struct MyGoalDetailContent: Equatable {
    let id: Int
    let title: String
    let startDate: Date
    let endDate: Date
    let selected: SelectedGoal
    let totalProgress: Double
    let description: GoalDetailDescription
    let comment: Comment

    static func == (lhs: MyGoalDetailContent, rhs: MyGoalDetailContent) -> Bool {
        lhs.id == rhs.id
    }
}

struct Todo: Identifiable, Equatable {
    let id: Int
    let todoDate: Date
    let description: String
    let status: String
}

struct GoalDetailDescription {
    let title: String
    let mentor: String
}

struct Comment: Identifiable, Equatable {
    let id: Int
    let comment: String
    let date: Date
    let mentor: String
}

protocol DetailGoal: Identifiable, Equatable {
    var id: Int { get }
    var date: Date { get }
}

struct DefaultGoal: DetailGoal {
    let id: Int
    let date: Date
}

struct SelectedGoal: DetailGoal {
    let id: Int
    let date: Date
    let todoList: [Todo]
    let todayProgress: Double
}

//extension MyGoalDetailContent {
//    static var dummy: MyGoalDetailContent {
//        .init(
//            id: 1,
//            title: "다온과 함께하는 영어 완전 정복 30일",
//            date: Date(),
//            todoList: <#T##[Todo]#>,
//            todayProgress: <#T##Double#>,
//            totalProgress: <#T##Double#>,
//            description: <#T##GoalDetailDescription#>,
//comment: <#T##Comment#>
//        )
//    }
//}
