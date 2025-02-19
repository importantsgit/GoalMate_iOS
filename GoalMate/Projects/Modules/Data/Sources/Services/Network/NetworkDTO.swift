//
//  NetworkDTO.swift
//  Data
//
//  Created by Importants on 2/5/25.
//

import Foundation

struct DefaultResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
}

// MARK: - Response
struct Response<T: Codable>: Codable {
    let status: String
    let code: String
    let message: String
    let data: T
}

public struct PaginationRequestDTO: Codable {
    let page: Int
    let size: Int
}

public struct RefreshTokenRequestDTO: Codable {
    let refreshToken: String
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
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
                case upcoming   = "UPCOMING"
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
            case upcoming   = "UPCOMING"
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

       // MARK: - MenteeGoal
       public struct MenteeGoal: Codable {
           public let id: Int
           public let title: String?
           public let topic: String?
           public let mentorName: String?
           public let mainImage: String?
           public let startDate: String?
           public let endDate: String?
           public let finalComment: String?
           public let todayTodoCount: Int?
           public let todayCompletedCount: Int?
           public let todayRemainingCount: Int?
           public let totalTodoCount: Int?
           public let totalCompletedCount: Int?
           public let menteeGoalStatus: MenteeGoalStatus?
           public let createdAt: String?
           public let updatedAt: String?
           public enum MenteeGoalStatus: String, Codable {
               case inProgress  = "IN_PROGRESS"
               case completed   = "COMPLETED"
               case failed      = "FAILED"
               case canceled    = "CANCELED"
           }
           public enum CodingKeys: String, CodingKey {
               case id, title, topic
               case mentorName = "mentor_name"
               case mainImage = "main_image"
               case startDate = "start_date"
               case endDate = "end_date"
               case finalComment = "final_comment"
               case todayTodoCount = "today_todo_count"
               case todayCompletedCount = "today_completed_count"
               case todayRemainingCount = "today_remaining_count"
               case totalTodoCount = "total_todo_count"
               case totalCompletedCount = "total_completed_count"
               case menteeGoalStatus = "mentee_goal_status"
               case createdAt = "created_at"
               case updatedAt = "updated_at"
           }
       }
       
       // MARK: - Page
       public struct Page: Codable {
           public let totalElements: Int?
           public let totalPages: Int?
           public let currentPage: Int?
           public let pageSize: Int?
           public let nextPage: Int?
           public let prevPage: Int?
           public let hasNext: Bool?
           public let hasPrev: Bool?
           
           public enum CodingKeys: String, CodingKey {
               case totalElements = "totalElements"
               case totalPages = "totalPages"
               case currentPage = "currentPage"
               case pageSize = "pageSize"
               case nextPage = "nextPage"
               case prevPage = "prevPage"
               case hasNext = "hasNext"
               case hasPrev = "hasPrev"
           }
       }
   }
}

public struct FetchMyGoalDetailResponseDTO: Codable {
   let status: String
   let code: String
   let message: String
   let data: Response?
   
   public struct Response: Codable {
       public let date: String?
       public let menteeGoal: MenteeGoal?
       public let todos: [Todo]?
       
       public enum CodingKeys: String, CodingKey {
           case date
           case menteeGoal = "mentee_goal"
           case todos
       }
       
       // MARK: - MenteeGoal
       public struct MenteeGoal: Codable {
           public let id: Int
           public let title: String?
           public let topic: String?
           public let mentorName: String?
           public let mainImage: String?
           public let startDate: String?
           public let endDate: String?
           public let mentorLetter: String?
           public let todayTodoCount: Int?
           public let todayCompletedCount: Int?
           public let todayRemainingCount: Int?
           public let totalTodoCount: Int?
           public let totalCompletedCount: Int?
           public let menteeGoalStatus: MenteeGoalStatus?
           public let createdAt: String?
           public let updatedAt: String?
           
           public enum MenteeGoalStatus: String, Codable {
               case inProgress = "IN_PROGRESS"
               case completed = "COMPLETED"
               case failed = "FAILED"
               case canceled = "CANCELED"
           }
           
           public enum CodingKeys: String, CodingKey {
               case id, title, topic
               case mentorName = "mentor_name"
               case mainImage = "main_image"
               case startDate = "start_date"
               case endDate = "end_date"
               case mentorLetter = "mentor_letter"
               case todayTodoCount = "today_todo_count"
               case todayCompletedCount = "today_completed_count"
               case todayRemainingCount = "today_remaining_count"
               case totalTodoCount = "total_todo_count"
               case totalCompletedCount = "total_completed_count"
               case menteeGoalStatus = "mentee_goal_status"
               case createdAt = "created_at"
               case updatedAt = "updated_at"
           }
       }
       
       // MARK: - Todo
       public struct Todo: Codable {
           public let id: Int
           public let todoDate: String?
           public let estimatedMinutes: Int?
           public let description: String?
           public let mentorTip: String?
           public let todoStatus: TodoStatus?
 
           public enum TodoStatus: String, Codable {
               case todo = "TODO"
               case inProgress = "IN_PROGRESS"
               case completed = "COMPLETED"
           }
  
           public enum CodingKeys: String, CodingKey {
               case id
               case todoDate = "todo_date"
               case estimatedMinutes = "estimated_minutes"
               case description
               case mentorTip = "mentor_tip"
               case todoStatus = "todo_status"
           }
       }
   }
}

public struct FetchWeeklyProgressResponseDTO: Codable {
   let status: String
   let code: String
   let message: String
   let data: Response?
   
   public struct Response: Codable {
       public let progress: [DailyProgress]?
       public let hasLastWeek: Bool?
       public let hasNextWeek: Bool?
       
       public enum CodingKeys: String, CodingKey {
           case progress
           case hasLastWeek = "has_last_week"
           case hasNextWeek = "has_next_week"
       }
       
       // MARK: - DailyProgress
       public struct DailyProgress: Codable {
           public let dailyTodoCount: Int?
           public let completedDailyTodoCount: Int?
           public let date: String?
           public let dayOfWeek: DayOfWeek?
           public let isValid: Bool?
           
           public enum DayOfWeek: String, Codable {
               case sunday = "SUN"
               case monday = "MON"
               case tuesday = "TUE"
               case wednesday = "WED"
               case thursday = "THU"
               case friday = "FRI"
               case saturday = "SAT"
           }
           
           public enum CodingKeys: String, CodingKey {
               case dailyTodoCount = "daily_todo_count"
               case completedDailyTodoCount = "completed_daily_todo_count"
               case date
               case dayOfWeek = "day_of_week"
               case isValid = "is_valid"
           }
       }
   }
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
                    goalStatus: .open,
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
                    goalStatus: .closed,
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
                    goalStatus: .upcoming,
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
            goalStatus: .open,
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

extension FetchMyGoalsResponseDTO {
    public static let dummy = FetchMyGoalsResponseDTO(
        status: "SUCCESS",
        code: "200",
        message: "정상적으로 처리되었습니다.",
        data: Response(
            menteeGoals: [
                Response.MenteeGoal(
                    id: 1,
                    title: "다온과 함께하는 영어 완전 정복 30일 목표",
                    topic: "영어",
                    mentorName: "다온",
                    mainImage: "https://example.com/images/english-study.jpg",
                    startDate: "2025-02-01",
                    endDate: "2025-03-01",
                    finalComment: "열심히 해봅시다!",
                    todayTodoCount: 5,
                    todayCompletedCount: 3,
                    todayRemainingCount: 2,
                    totalTodoCount: 100,
                    totalCompletedCount: 45,
                    menteeGoalStatus: .inProgress,
                    createdAt: "2025-02-01T09:00:00.000Z",
                    updatedAt: "2025-02-19T15:30:00.000Z"
                ),
                Response.MenteeGoal(
                    id: 2,
                    title: "하루 30분 코딩 챌린지",
                    topic: "프로그래밍",
                    mentorName: "지훈",
                    mainImage: "https://example.com/images/coding.jpg",
                    startDate: "2025-02-10",
                    endDate: "2025-03-10",
                    finalComment: "코딩의 기초를 다져봅시다",
                    todayTodoCount: 3,
                    todayCompletedCount: 3,
                    todayRemainingCount: 0,
                    totalTodoCount: 90,
                    totalCompletedCount: 20,
                    menteeGoalStatus: .inProgress,
                    createdAt: "2025-02-10T10:00:00.000Z",
                    updatedAt: "2025-02-19T14:20:00.000Z"
                ),
                Response.MenteeGoal(
                    id: 3,
                    title: "다온과 함께하는 영어 완전 정복 30일 목표, 다온과 함께하는 영어 완전 정복 30일 목표",
                    topic: "영어",
                    mentorName: "다온",
                    mainImage: "https://example.com/images/english-study.jpg",
                    startDate: "2025-02-01",
                    endDate: "2025-03-01",
                    finalComment: "열심히 해봅시다!",
                    todayTodoCount: 5,
                    todayCompletedCount: 3,
                    todayRemainingCount: 2,
                    totalTodoCount: 100,
                    totalCompletedCount: 45,
                    menteeGoalStatus: .inProgress,
                    createdAt: "2025-02-01T09:00:00.000Z",
                    updatedAt: "2025-02-19T15:30:00.000Z"
                ),
                Response.MenteeGoal(
                    id: 4,
                    title: "하루 30분 코딩 챌린지",
                    topic: "프로그래밍",
                    mentorName: "지훈",
                    mainImage: "https://example.com/images/coding.jpg",
                    startDate: "2025-02-10",
                    endDate: "2025-03-10",
                    finalComment: "코딩의 기초를 다져봅시다",
                    todayTodoCount: 3,
                    todayCompletedCount: 3,
                    todayRemainingCount: 0,
                    totalTodoCount: 90,
                    totalCompletedCount: 20,
                    menteeGoalStatus: .inProgress,
                    createdAt: "2025-02-10T10:00:00.000Z",
                    updatedAt: "2025-02-19T14:20:00.000Z"
                ),
                Response.MenteeGoal(
                    id: 5,
                    title: "다온과 함께하는 영어 완전 정복 30일 목표",
                    topic: "영어",
                    mentorName: "다온",
                    mainImage: "https://example.com/images/english-study.jpg",
                    startDate: "2025-02-01",
                    endDate: "2025-03-01",
                    finalComment: "열심히 해봅시다!",
                    todayTodoCount: 5,
                    todayCompletedCount: 3,
                    todayRemainingCount: 2,
                    totalTodoCount: 100,
                    totalCompletedCount: 45,
                    menteeGoalStatus: .inProgress,
                    createdAt: "2025-02-01T09:00:00.000Z",
                    updatedAt: "2025-02-19T15:30:00.000Z"
                ),
                Response.MenteeGoal(
                    id: 6,
                    title: "하루 30분 코딩 챌린지",
                    topic: "프로그래밍",
                    mentorName: "지훈",
                    mainImage: "https://example.com/images/coding.jpg",
                    startDate: "2025-02-10",
                    endDate: "2025-03-10",
                    finalComment: "코딩의 기초를 다져봅시다",
                    todayTodoCount: 3,
                    todayCompletedCount: 3,
                    todayRemainingCount: 0,
                    totalTodoCount: 90,
                    totalCompletedCount: 20,
                    menteeGoalStatus: .inProgress,
                    createdAt: "2025-02-10T10:00:00.000Z",
                    updatedAt: "2025-02-19T14:20:00.000Z"
                ),
                Response.MenteeGoal(
                    id: 7,
                    title: "다온과 함께하는 영어 완전 정복 30일 목표",
                    topic: "영어",
                    mentorName: "다온",
                    mainImage: "https://example.com/images/english-study.jpg",
                    startDate: "2025-02-01",
                    endDate: "2025-03-01",
                    finalComment: "열심히 해봅시다!",
                    todayTodoCount: 5,
                    todayCompletedCount: 3,
                    todayRemainingCount: 2,
                    totalTodoCount: 100,
                    totalCompletedCount: 45,
                    menteeGoalStatus: .inProgress,
                    createdAt: "2025-02-01T09:00:00.000Z",
                    updatedAt: "2025-02-19T15:30:00.000Z"
                ),
                Response.MenteeGoal(
                    id: 8,
                    title: "하루 30분 코딩 챌린지",
                    topic: "프로그래밍",
                    mentorName: "지훈",
                    mainImage: "https://example.com/images/coding.jpg",
                    startDate: "2025-02-10",
                    endDate: "2025-03-10",
                    finalComment: "코딩의 기초를 다져봅시다",
                    todayTodoCount: 3,
                    todayCompletedCount: 3,
                    todayRemainingCount: 0,
                    totalTodoCount: 90,
                    totalCompletedCount: 20,
                    menteeGoalStatus: .inProgress,
                    createdAt: "2025-02-10T10:00:00.000Z",
                    updatedAt: "2025-02-19T14:20:00.000Z"
                )
            ],
            page: Response.Page(
                totalElements: 8,
                totalPages: 4,
                currentPage: 1,
                pageSize: 2,
                nextPage: 2,
                prevPage: nil,
                hasNext: true,
                hasPrev: false
            )
        )
    )
}

extension FetchMyGoalDetailResponseDTO {
   public static let dummy = FetchMyGoalDetailResponseDTO(
       status: "SUCCESS",
       code: "200",
       message: "정상적으로 처리되었습니다.",
       data: Response(
           date: "2025-02-18",
           menteeGoal: Response.MenteeGoal(
               id: 1,
               title: "다온과 함께하는 영어 완전 정복 30일 목표",
               topic: "영어",
               mentorName: "다온",
               mainImage: "https://main-image.url",
               startDate: "2025-02-18",
               endDate: "2025-02-18",
               mentorLetter: "오늘도 열심히 해봅시다!",
               todayTodoCount: 5,
               todayCompletedCount: 3,
               todayRemainingCount: 2,
               totalTodoCount: 100,
               totalCompletedCount: 50,
               menteeGoalStatus: .inProgress,
               createdAt: "2025-02-18T17:56:07.894Z",
               updatedAt: "2025-02-18T17:56:07.894Z"
           ),
           todos: [
               Response.Todo(
                   id: 1,
                   todoDate: "2025-02-18",
                   estimatedMinutes: 50,
                   description: "영어 단어 보카 30개 암기",
                   mentorTip: "예문을 반드시 5회 이상 읽어보세요!",
                   todoStatus: .todo
               ),
               Response.Todo(
                   id: 2,
                   todoDate: "2025-02-18",
                   estimatedMinutes: 30,
                   description: "리스닝 연습하기",
                   mentorTip: "스크립트를 먼저 읽고 들어보세요",
                   todoStatus: .completed
               )
           ]
       )
   )
}

extension FetchWeeklyProgressResponseDTO {
   public static let dummy = FetchWeeklyProgressResponseDTO(
       status: "SUCCESS",
       code: "200",
       message: "정상적으로 처리되었습니다.",
       data: Response(
           progress: [
               Response.DailyProgress(
                   dailyTodoCount: 5,
                   completedDailyTodoCount: 3,
                   date: "2025-02-17",
                   dayOfWeek: .monday,
                   isValid: true
               ),
               Response.DailyProgress(
                   dailyTodoCount: 4,
                   completedDailyTodoCount: 4,
                   date: "2025-02-18",
                   dayOfWeek: .tuesday,
                   isValid: true
               ),
               Response.DailyProgress(
                   dailyTodoCount: 6,
                   completedDailyTodoCount: 2,
                   date: "2025-02-19",
                   dayOfWeek: .wednesday,
                   isValid: true
               ),
               Response.DailyProgress(
                   dailyTodoCount: 5,
                   completedDailyTodoCount: 0,
                   date: "2025-02-20",
                   dayOfWeek: .thursday,
                   isValid: false
               )
           ],
           hasLastWeek: true,
           hasNextWeek: true
       )
   )
}
