//
//  MenteeClient.swift
//  Data
//
//  Created by Importants on 2/11/25.
//

import Dependencies
import DependenciesMacros
import Foundation
import Utils

@DependencyClient
public struct MenteeClient {
    public var login: () async throws -> Void
    public var joinGoal: (_ goalId: Int) async throws -> Void
    public init(
        login: @escaping () -> Void,
        joinGoal: @escaping (_ goalId: Int) async throws -> Void
    ) {
        self.login = login
        self.joinGoal = joinGoal
    }
}

// MARK: - Live Implementation
extension MenteeClient: DependencyKey {
    public static var liveValue: MenteeClient {
        @Dependency(\.dataStorageClient) var dataStorageClient
        @Dependency(\.networkClient) var networkClient
        @Dependency(\.authClient) var authClient
        return .init(
            login: {
                let token = await dataStorageClient.tokenInfo
                do {
                    guard let accessToken = token.accessToken
                    else { throw LoginError.noToken }
                    let requestDTO = LoginRequestDTO(
                        accessToken: accessToken
                    )
//                    let endpoint = APIEndpoints.loginEndpoint(with: requestDTO)
//                    let response = try await networkClient.asyncRequest(with: endpoint)
//                    return response.isSuccess
                } catch {
                    // 로그인 실패시 토큰 갱신 시도
                    guard let refreshToken = token.refreshToken
                    else { throw LoginError.noToken }
                    let newToken = try await authClient.refresh(refreshToken)
                    let requestDTO = RefreshLoginRequestDTO(
                        refreshToken: newToken.refreshToken
                    )
//                    let endpoint = APIEndpoints.loginEndpoint(with: requestDTO)
//                    let response = try await networkClient.asyncRequest(with: endpoint)
//                    response.isSuccess
                }
            },
            joinGoal: { goalId in
                let token = await dataStorageClient.tokenInfo
                guard let accessToken = token.accessToken
                else { throw LoginError.noToken }
                let endpoint = try APIEndpoints.joinGoalEndpoint(
                    goalId: goalId,
                    accessToken: accessToken
                )
                let response = try await networkClient.asyncRequest(with: endpoint)
                switch response.code {
                case "200":
                    return
                case "403":
                    throw NetworkError.statusCodeError(code: 403)
                case "404":
                    throw NetworkError.statusCodeError(code: 404)
                case "409":
                    throw NetworkError.statusCodeError(code: 409)
                default:
                    throw NetworkError.invaildResponse
                }
            }
        )
    }

    public static var testValue = MenteeClient(
        login: {},
        joinGoal: { _ in }
    )

    public static var previewValue = MenteeClient(
        login: {},
        joinGoal: { _ in }
    )
}

// MARK: - Dependencies Registration
extension DependencyValues {
    public var menteeClient: MenteeClient {
        get { self[MenteeClient.self] }
        set { self[MenteeClient.self] = newValue }
    }
}
