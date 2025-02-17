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
        case refreshLogin       = "auth/reissue"
        case withdraw           = "auth/withdraw"

        case setNickname        = "mentees/my/name"
        case checkNickname      = "mentees/name/validate"
        case joinGoal           = "goals/{goalId}/mentees"
        case fetchMenteeInfo    = "mentees/my"

        case fetchGoals         = "goals"
        case fetchGoalDetail    = "goals/{goalId}"

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

    static func refreshLoginEndpoint(
        refreshToken: String
    ) -> Endpoint<AuthLoginResponseDTO> {
        Endpoint(
            path: APIPath.refreshLogin,
            method: .put,
            headerParameters: [
                "Authorization": "Bearer \(refreshToken)"
            ]
        )
    }
    
    static func withdrawEndpoint(
        accessToken: String
    ) -> Endpoint<Void> {
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
        with request: FetchGoalsRequestDTO
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
}
