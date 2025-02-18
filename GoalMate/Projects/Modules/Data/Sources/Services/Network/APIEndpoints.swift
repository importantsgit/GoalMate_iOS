//
//  APIEndPoints.swift
//  Data
//
//  Created by Importants on 2/5/25.
//

import Foundation

struct APIEndpoints {
    // Path prefix에 / 제거
    enum APIPath: String {
        case authLogin          = "auth/login"
        case refreshToken       = "auth/reissue"
        case validateToken          = "auth/validate"
        case withdraw               = "auth/withdraw"
        case logout                 = "auth/logout"

        case setNickname            = "mentees/my/name"
        case checkNickname          = "mentees/name/validate"
        case joinGoal               = "goals/{goalId}/mentees"
        case fetchMenteeInfo        = "mentees/my"

        case fetchGoals             = "goals"
        case fetchGoalDetail        = "goals/{goalId}"

        case fetchMyGoals           = "mentees/my/goals"
        case fetchMyGoalDetail      = "mentees/my/goals/{menteeGoalId}"
        case fetchWeeklyProgress    = "mentees/my/goals/{menteeGoalId}/weekly-progress"

        case updateTodo             = "mentees/my/goals/{menteeGoalId}/todos/{todoId}"
        
        case fetchCommentRooms      = "comment-rooms/my"
        case fetchCommentRoomDetail = "comment-rooms/{roomId}/comments"
        func path(with parameters: [String: String]) -> String {
            var result = self.rawValue
            parameters.forEach { key, value in
                result = result.replacingOccurrences(of: "{\(key)}", with: value)
            }
            return result
        }
    }

    static func authLoginEndpoint(
        with request: AuthLoginRequestDTO
    ) -> Endpoint<AuthLoginResponseDTO> {
        Endpoint(
            path: APIPath.authLogin,
            method: .post,
            bodyParametersEncodable: request
        )
    }

    static func refreshTokenEndpoint(
        with request: RefreshTokenRequestDTO
    ) -> Endpoint<AuthLoginResponseDTO> {
        Endpoint(
            path: APIPath.refreshToken,
            method: .put,
            bodyParametersEncodable: request
        )
    }

    static func validateTokenEndpoint(
        accessToken: String
    ) -> Endpoint<DefaultResponseDTO> {
        Endpoint(
            path: APIPath.validateToken,
            method: .get,
            headerParameters: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
    }

    static func authLogoutEndpoint(
        accessToken: String
    ) -> Endpoint<DefaultResponseDTO> {
        Endpoint(
            path: APIPath.logout,
            method: .put,
            headerParameters: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
    }

    static func withdrawEndpoint(
        accessToken: String
    ) -> Endpoint<DefaultResponseDTO> {
        Endpoint(
            path: .withdraw,
            method: .delete,
            headerParameters: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
    }

    static func setNicknameEndpoint(
        with request: SetNicknameRequestDTO,
        accessToken: String
    ) -> Endpoint<SetNicknameResponseDTO> {
        Endpoint(
            path: APIPath.setNickname,
            method: .put,
            headerParameters: [
                "Authorization": "Bearer \(accessToken)"
            ],
            queryParametersEncodable: request
        )
    }

    static func checkNicknameEndpoint(
        with request: CheckNicknameRequestDTO,
        accessToken: String
    ) -> Endpoint<CheckNicknameResponseDTO> {
        Endpoint(
            path: APIPath.checkNickname,
            method: .get,
            headerParameters: [
                "Authorization": "Bearer \(accessToken)"
            ],
            queryParametersEncodable: request
        )
    }

    static func fetchGoalEndpoint(
        with request: PaginationRequestDTO
    ) -> Endpoint<FetchGoalsResponseDTO> {
        Endpoint(
            path: .fetchGoals,
            method: .get,
            queryParametersEncodable: request
        )
    }

    static func fetchGoalDetailEndpoint(
        goalId: Int
    ) throws -> Endpoint<FetchGoalDetailResponseDTO> {
        try Endpoint(
            path: .fetchGoalDetail,
            pathParameters: [
                "goalId": "\(goalId)"
            ],
            method: .get
        )
    }

    static func joinGoalEndpoint(
        goalId: Int,
        accessToken: String
    ) throws -> Endpoint<JoinGoalResponseDTO> {
        try Endpoint(
            path: .joinGoal,
            pathParameters: [
                "goalId": "\(goalId)"
            ],
            method: .post,
            headerParameters: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
    }

    static func fetchMenteeInfoEndpoint(
        accessToken: String
    ) throws -> Endpoint<FetchMenteeInfoResponseDTO> {
        Endpoint(
            path: .fetchMenteeInfo,
            method: .get,
            headerParameters: [
                "Authorization": "Bearer \(accessToken)"
            ]
        )
    }
    
    static func fetchMyGoalsEndpoint(
        with request: PaginationRequestDTO,
        accessToken: String
    ) -> Endpoint<FetchMyGoalsResponseDTO> {
        return Endpoint(
            path: .fetchMyGoals,
            method: .get,
            headerParameters: [
                "Authorization": "Bearer \(accessToken)"
            ],
            queryParametersEncodable: request
        )
    }

    static func fetchMyGoalDetailEndpoint(
        menteeGoalId: Int,
        date: String,
        accessToken: String
    ) throws -> Endpoint<FetchMyGoalDetailResponseDTO> {
        try Endpoint(
            path: .fetchMyGoalDetail,
            pathParameters: [
                "menteeGoalId": "\(menteeGoalId)"
            ],
            method: .get,
            headerParameters: [
                "Authorization": "Bearer \(accessToken)"
            ],
            queryParameters: [
                "date": date
            ]
        )
    }

    static func fetchWeeklyProgressEndpoint(
        menteeGoalId: Int,
        date: String,
        accessToken: String
    ) throws -> Endpoint<FetchWeeklyProgressResponseDTO> {
        try Endpoint(
            path: .fetchWeeklyProgress,
            pathParameters: [
                "menteeGoalId": "\(menteeGoalId)"
            ],
            method: .get,
            headerParameters: [
                "Authorization": "Bearer \(accessToken)"
            ],
            queryParameters: [
                "date": date
            ]
        )
    }
}
