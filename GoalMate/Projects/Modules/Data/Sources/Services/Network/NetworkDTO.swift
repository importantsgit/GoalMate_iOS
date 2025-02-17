//
//  NetworkDTO.swift
//  Data
//
//  Created by Importants on 2/5/25.
//

import Foundation

// MARK: - Response
struct Response<T: Codable>: Codable {
    let status: String
    let code: String
    let message: String
    let data: T
}

public struct AuthLoginRequestDTO: Codable {
    let identityToken: String
    let nonce: String
    let provider: String
    enum CodingKeys: String, CodingKey {
        case identityToken = "identity_token"
        case nonce, provider
    }
}

public struct AuthLoginResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: Response
    struct Response: Codable {
        let accessToken: String
        let refreshToken: String
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case refreshToken = "refresh_token"
        }
    }
}

public struct LoginRequestDTO: Codable {
    let accessToken: String
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}

public struct RefreshLoginRequestDTO: Codable {
    let refreshToken: String
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}

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

public struct FetchGoalsRequestDTO: Codable {
    let page: Int
    let size: Int
}

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
            public enum GoalStatus: String, Codable {
                case inProgress = "IN_PROGRESS"
                case notStarted = "NOT_STARTED"
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
                case mainImage = "main_image"
            }
        }
        // MARK: - Page
        public struct Page: Codable {
            let totalElements, totalPages, currentPage, pageSize: Int?
            let nextPage, prevPage: Int?
            public let hasNext, hasPrev: Bool?
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
        public enum GoalStatus: String, Codable {
            case notStarted = "NOT_STARTED"
            case inProgress = "IN_PROGRESS"
            case closed = "CLOSED"
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
}

extension FetchGoalsResponseDTO {
    static let dummyList = FetchGoalsResponseDTO(
        status: "SUCCESS",
        code: "200",
        message: "정상적으로 처리되었습니다.",
        data: .init(
            goals: [
                .init(
                    id: 1,
                    title: "다온과 함께하는 영어 완전 정복 30일 목표",
                    topic: "영어",
                    description: "영어를 하고 싶었지만 어떤 방법으로 해야 할 지, 루틴을 세우지만 어떤 방법이 효율적일지 고민이 많지 않았나요?",
                    period: 30,
                    dailyDuration: 4,
                    participantsLimit: 10,
                    currentParticipants: 5,
                    isClosingSoon: true,
                    goalStatus: .inProgress,
                    mentorName: "다온",
                    createdAt: "2025-02-13T15:30:00Z",
                    updatedAt: "2025-02-13T15:30:00Z",
                    mainImage: "https://example.com/main1.jpg"
                ),
                .init(
                    id: 2,
                    title: "매일 운동하기 프로젝트",
                    topic: "운동",
                    description: "하루 30분 운동으로 건강한 습관 만들기",
                    period: 30,
                    dailyDuration: 1,
                    participantsLimit: 20,
                    currentParticipants: 15,
                    isClosingSoon: false,
                    goalStatus: .inProgress,
                    mentorName: "건강이",
                    createdAt: "2025-02-13T15:30:00Z",
                    updatedAt: "2025-02-13T15:30:00Z",
                    mainImage: "https://example.com/main2.jpg"
                ),
                .init(
                    id: 3,
                    title: "프로그래밍 기초 마스터하기",
                    topic: "개발",
                    description: "코딩의 기초부터 실전 프로젝트까지",
                    period: 60,
                    dailyDuration: 2,
                    participantsLimit: 15,
                    currentParticipants: 8,
                    isClosingSoon: false,
                    goalStatus: .inProgress,
                    mentorName: "코드마스터",
                    createdAt: "2025-02-13T15:30:00Z",
                    updatedAt: "2025-02-13T15:30:00Z",
                    mainImage: "https://example.com/main3.jpg"
                )
            ],
            page: .init(
                totalElements: 123,
                totalPages: 13,
                currentPage: 1,
                pageSize: 10,
                nextPage: 2,
                prevPage: 0,
                hasNext: true,
                hasPrev: false
            )
        )
    )
}

extension FetchGoalDetailResponseDTO {
    static let dummy = FetchGoalDetailResponseDTO(
        status: "SUCCESS",
        code: "200",
        message: "정상적으로 처리되었습니다.",
        data: .init(
            id: 1,
            title: "다온과 함께하는 영어 완전 정복 30일 목표",
            topic: "영어",
            description: "영어를 하고 싶었지만 어떤 방법으로 해야 할 지, 루틴을 세우지만 어떤 방법이 효율적일지 고민이 많지 않았나요?",
            period: 30,
            dailyDuration: 4,
            participantsLimit: 10,
            currentParticipants: 5,
            isClosingSoon: true,
            goalStatus: .inProgress,
            mentorName: "다온",
            createdAt: nil,
            updatedAt: nil,
            weeklyObjectives: [
                .init(weekNumber: 1, description: "간단한 단어부터 시작하기"),
                .init(weekNumber: 2, description: "기초 문법 마스터하기"),
                .init(weekNumber: 3, description: "일상 회화 연습하기"),
                .init(weekNumber: 4, description: "자신감 있게 대화하기")
            ],
            midObjectives: [
                .init(number: 1, description: "영어로 원어민과 편안하게 대화하는 법"),
                .init(number: 2, description: "영어 공부 루틴 만들기"),
                .init(number: 3, description: "회화에 자주 쓰이는 표현 익히기")
            ],
            thumbnailImages: [
                .init(sequence: 1, imageUrl: "https://example.com/thumbnail1.jpg"),
                .init(sequence: 1, imageUrl: "https://example.com/thumbnail2.jpg")
            ],
            contentImages: [
                .init(sequence: 1, imageUrl: "https://example.com/thumbnail1.jpg"),
                .init(sequence: 1, imageUrl: "https://example.com/thumbnail2.jpg")
            ]
        )
    )
}

extension FetchMenteeInfoResponseDTO {
    static let dummy = FetchMenteeInfoResponseDTO(
        status: "SUCCESS",
        code: "200",
        message: "정상적으로 처리되었습니다.",
        data: .init(
            id: 1,
            name: "김멘티",
            inProgressGoalCount: 10,
            completedGoalCount: 2,
            freeParticipationCount: 30,
            menteeStatus: .active
        )
    )
}
