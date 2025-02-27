//
//  Goal.swift
//  Data
//
//  Created by 이재훈 on 2/27/25.
//

import Foundation

public struct FetchGoalsResponseDTO: Codable {
    public let goals: [Goal]
    public let page: Page?
    public enum CodingKeys: String, CodingKey {
        case goals, page
    }
}

// MARK: - Goal
public struct Goal: Codable {
    public let id: Int
    public let title: String?
    public let topic: String?
    public let description: String?
    public let period: Int?
    public let dailyDuration: Int?
    public let participantsLimit: Int?
    public let currentParticipants: Int?
    public let isClosingSoon: Bool?
    public let goalStatus: GoalStatus?
    public let mentorName: String?
    public let createdAt: String?
    public let updatedAt: String?
    public let mainImage: String?
    public enum CodingKeys: String, CodingKey {
        case id, title, topic, description, period
        case dailyDuration = "daily_duration"
        case participantsLimit = "participants_limit"
        case currentParticipants = "current_participants"
        case isClosingSoon = "is_closing_soon"
        case goalStatus = "goal_status"
        case mentorName = "mentor_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mainImage = "main_image"
    }
}

extension Goal: Identifiable, Equatable {}

public struct GoalDetail: Codable, Identifiable, Equatable {
    public let id: Int
    public let title: String?
    public let topic: String?
    public let description: String?
    public let period: Int?
    public let dailyDuration: Int?
    public let participantsLimit: Int?
    public let currentParticipants: Int?
    public let isClosingSoon: Bool?
    public let goalStatus: GoalStatus?
    public let mentorName: String?
    public let createdAt: String?
    public let updatedAt: String?
    public let weeklyObjectives: [WeeklyObjective]
    public let midObjectives: [MidObjective]
    public let thumbnailImages: [ContentImage]
    public let contentImages: [ContentImage]
    public let isParticipated: Bool?

    public enum CodingKeys: String, CodingKey {
        case id, title, topic, description, period
        case dailyDuration = "daily_duration"
        case participantsLimit = "participants_limit"
        case currentParticipants = "current_participants"
        case isClosingSoon = "is_closing_soon"
        case goalStatus = "goal_status"
        case mentorName = "mentor_name"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case weeklyObjectives = "weekly_objectives"
        case midObjectives = "mid_objectives"
        case thumbnailImages = "thumbnail_images"
        case contentImages = "content_images"
        case isParticipated = "is_participated"
    }
}

public struct WeeklyObjective: Codable, Identifiable, Equatable {
    public var id: Int { weekNumber }
    public let weekNumber: Int
    public let description: String?
    enum CodingKeys: String, CodingKey {
        case weekNumber = "week_number"
        case description
    }
}
public struct MidObjective: Codable, Identifiable, Equatable {
    public var id: Int { sequence }
    public let sequence: Int
    public let description: String?
    public enum CodingKeys: String, CodingKey {
        case sequence, description
    }
}
public struct ContentImage: Codable, Identifiable, Equatable {
    public var id: Int { sequence }
    public let sequence: Int
    public let imageUrl: String?
    public enum CodingKeys: String, CodingKey {
        case sequence, imageUrl
    }
}

public enum GoalStatus: String, Codable, Equatable {
    case open       = "OPEN"
    case closed     = "CLOSED"
}

extension GoalDetail {
   static func getDummy(
    isParticipated: Bool = false
   ) -> GoalDetail {
       return GoalDetail(
           id: 1,
           title: "다온과 함께하는 영어 완전 정복 30일 목표",
           topic: "영어",
           description: "영어를 하고 싶었지만 어떤 방법으로 해야 할 지, 루틴을 세우지만 어떤 방법이 효율적일지 고민이 많지 않았나요?",
           period: 30,
           dailyDuration: 4,
           participantsLimit: 10,
           currentParticipants: 5,
           isClosingSoon: true,
           goalStatus: .open,
           mentorName: "다온",
           createdAt: "2025-02-27T00:49:42.838Z",
           updatedAt: "2025-02-27T00:49:42.838Z",
           weeklyObjectives: [
               .init(weekNumber: 1, description: "간단한 단어부터 시작하기"),
               .init(weekNumber: 2, description: "기초 문법 마스터하기"),
               .init(weekNumber: 3, description: "일상 회화 연습하기"),
               .init(weekNumber: 4, description: "자신감 있게 대화하기")
           ],
           midObjectives: [
               .init(sequence: 1, description: "영어로 원어민과 편안하게 대화하는 법"),
               .init(sequence: 2, description: "영어 공부 루틴 만들기"),
               .init(sequence: 3, description: "회화에 자주 쓰이는 표현 익히기")
           ],
           thumbnailImages: [
               .init(sequence: 1, imageUrl: "https://picsum.photos/200/300"),
               .init(sequence: 2, imageUrl: "https://picsum.photos/200/300"),
               .init(sequence: 3, imageUrl: "https://picsum.photos/200/300"),
               .init(sequence: 4, imageUrl: "https://picsum.photos/200/300")
           ],
           contentImages: [
               .init(sequence: 1, imageUrl: "https://picsum.photos/200/300"),
               .init(sequence: 2, imageUrl: "https://picsum.photos/200/300"),
               .init(sequence: 3, imageUrl: "https://picsum.photos/200/300"),
               .init(sequence: 4, imageUrl: "https://picsum.photos/200/300")
           ],
           isParticipated: isParticipated
       )
   }
}
