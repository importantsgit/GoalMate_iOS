//
//  Mentee.swift
//  Data
//
//  Created by 이재훈 on 2/27/25.
//

import Foundation

public struct SetNicknameRequestDTO: Codable {
    let name: String
}

public struct SetNicknameResponseDTO: Codable {
    let data: String
}

public struct CheckNicknameRequestDTO: Codable {
    let name: String
}

public struct CheckNicknameResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: Response?
    public struct Response: Codable {
        let isAvailable: Bool
        public enum CodingKeys: String, CodingKey {
            case isAvailable = "is_available"
        }
    }
}

public struct CheckTodosResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: Response?
    public struct Response: Codable {
        let hasRemainingTodosToday: Bool
    }
}

public struct FetchMenteeInfoResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: Response?
    public struct Response: Codable {
        public let id: Int
        public let name: String?
        public let inProgressGoalCount: Int?
        public let completedGoalCount: Int?
        public let freeParticipationCount: Int?
        public let menteeStatus: MenteeStatus?
        public enum MenteeStatus: String, Codable {
            case pending    = "PENDING"
            case active     = "ACTIVE"
            case deleted    = "DELETED"
        }
        public enum CodingKeys: String, CodingKey {
            case id, name
            case inProgressGoalCount = "in_progress_goal_count"
            case completedGoalCount = "completed_goal_count"
            case freeParticipationCount = "free_participation_count"
            case menteeStatus = "mentee_status"
        }
    }
}

public struct FetchMyGoalsResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: Response?

    public struct Response: Codable {
        public let menteeGoals: [MenteeGoal]
        public let page: Page?

        public enum CodingKeys: String, CodingKey {
            case menteeGoals = "mentee_goals"
            case page
        }
    }
}

public struct FetchMyGoalDetailResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: Response?

    public struct Response: Codable, Identifiable, Equatable {
        public var id: String { date }

        public let date: String
        public var menteeGoal: MenteeGoal?
        public var todos: [Todo]

        public enum CodingKeys: String, CodingKey {
            case date
            case menteeGoal = "mentee_goal"
            case todos
        }

        public static func == (
            lhs: FetchMyGoalDetailResponseDTO.Response,
            rhs: FetchMyGoalDetailResponseDTO.Response) -> Bool {
            lhs.id == rhs.id
        }
    }
}

public struct FetchWeeklyProgressResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: Response?

    public struct Response: Codable {
        public let progress: [DailyProgress]
        public let hasLastWeek: Bool?
        public let hasNextWeek: Bool?

        public enum CodingKeys: String, CodingKey {
            case progress
            case hasLastWeek = "has_last_week"
            case hasNextWeek = "has_next_week"
        }
    }
}

public struct PatchTodoRequestDTO: Codable {
    let todoStatus: TodoStatus
    public enum CodingKeys: String, CodingKey {
        case todoStatus = "todo_status"
    }
}

public struct PatchTodoResponseDTO: Codable {
   let status: String
   let code: String
   let message: String
   let data: Todo?
}
