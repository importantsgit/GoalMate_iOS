//
//  APIEndPoints.swift
//  Data
//
//  Created by Importants on 2/5/25.
//

import Foundation

struct APIEndPoints {
    // Path prefix에 / 제거
    enum APIPath: String {
        case authLogin          = "auth/login"
        case refreshLogin       = "auth/reissue"

        case goalDetail         = "goals/{goalId}"

        func path(with parameters: [String: String]) -> String {
            var result = self.rawValue
            parameters.forEach { key, value in
                result = result.replacingOccurrences(of: "{\(key)}", with: value)
            }
            return result
        }
    }

    static func authLoginEndPoint(
        with request: AuthLoginRequestDTO
    ) -> EndPoint<AuthLoginResponseDTO> {
        EndPoint(
            path: APIPath.authLogin,
            method: .get,
            queryParametersEncodable: request
        )
    }

    static func refreshLoginEndPoint(
        with request: RefreshLoginRequestDTO
    ) -> EndPoint<AuthLoginResponseDTO> {
        EndPoint(
            path: APIPath.refreshLogin,
            method: .get,
            queryParametersEncodable: request
        )
    }

    static func goalDetailEndPoint(
        goalId: String,
        with request: TokenResponse
    ) throws -> EndPoint<TokenResponse> {
        try EndPoint(
            path: APIPath.authLogin,
            pathParameters: ["goalId": goalId],
            method: .get,
            queryParametersEncodable: request
        )
    }
}
