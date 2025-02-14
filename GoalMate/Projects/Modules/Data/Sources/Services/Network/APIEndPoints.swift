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
        case setNickname        = "mentees/my/name"
        case checkNickname      = "mentees/name/validate"

        case goalDetail         = "goals/{goalId}"

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
        with request: RefreshLoginRequestDTO
    ) -> Endpoint<AuthLoginResponseDTO> {
        Endpoint(
            path: APIPath.refreshLogin,
            method: .get,
            queryParametersEncodable: request
        )
    }

    static func goalDetailEndpoint(
        goalId: String,
        with request: TokenResponse
    ) throws -> Endpoint<TokenResponse> {
        try Endpoint(
            path: APIPath.authLogin,
            pathParameters: ["goalId": goalId],
            method: .get,
            queryParametersEncodable: request
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
        with request: checkNicknameRequestDTO,
        accessToken: String
    ) -> Endpoint<checkNicknameResponseDTO> {
        Endpoint(
            path: APIPath.checkNickname,
            method: .get,
            headerParameters: [
                "Authorization": "Bearer \(accessToken)"
            ],
            queryParametersEncodable: request
        )
    }
}
