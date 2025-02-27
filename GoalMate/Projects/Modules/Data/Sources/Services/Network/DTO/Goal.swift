//
//  Goal.swift
//  Data
//
//  Created by 이재훈 on 2/27/25.
//

import Foundation

public struct FetchGoalsResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: Response?
    public struct Response: Codable {
        public let goals: [Goal]
        public let page: Page?
        public enum CodingKeys: String, CodingKey {
            case goals, page
        }
    }
}

public struct FetchGoalDetailResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: Response?
    public struct Response: Codable {
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
        public let isParticipated: Bool
        public enum GoalStatus: String, Codable {
            case open       = "OPEN"
            case closed     = "CLOSED"
        }
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
        public struct WeeklyObjective: Codable {
            public let weekNumber: Int?
            public let description: String?
            enum CodingKeys: String, CodingKey {
                case weekNumber = "week_number"
                case description
            }
        }
        public struct MidObjective: Codable {
            public let number: Int?
            public let description: String?
        }
        public struct ContentImage: Codable {
            public let sequence: Int?
            public let imageUrl: String?
        }
    }
}

struct JoinGoalResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: Int
}
