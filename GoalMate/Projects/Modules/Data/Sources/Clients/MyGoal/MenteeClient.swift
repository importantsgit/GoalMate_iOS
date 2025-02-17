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
    public var fetchMenteeInfo: () async throws -> FetchMenteeInfoResponseDTO.Response
    public var joinGoal: (_ goalId: Int) async throws -> Void
    public init(
        login: @escaping () -> Void,
        fetchMenteeInfo: @escaping () -> FetchMenteeInfoResponseDTO.Response,
        joinGoal: @escaping (_ goalId: Int) async throws -> Void
    ) {
        self.login = login
        self.fetchMenteeInfo = fetchMenteeInfo
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
            fetchMenteeInfo: {
                func fetch(with token: String) async throws -> FetchMenteeInfoResponseDTO.Response {
                    let endpoint = try APIEndpoints.fetchMenteeInfoEndpoint(
                        accessToken: token
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    guard let data = response.data else { throw NetworkError.emptyData }
                    return data
                }
                let token = await dataStorageClient.tokenInfo
                guard let accessToken = token.accessToken else {
                    throw LoginError.noToken
                }
                do {
                    return try await fetch(with: accessToken)
                } catch let error as NetworkError {
                    if case let .statusCodeError(code) = error,
                        code == 401 {
                        // 토큰이 만료된 경우
                        guard let refreshToken = token.refreshToken
                        else { throw LoginError.noToken }
                        // 리프레시 토큰으로 새 액세스 토큰 발급
                        let newToken = try await authClient.refresh(
                            token: refreshToken
                        )
                        // 새 토큰으로 재시도
                        return try await fetch(with: newToken.accessToken)
                    }
                    throw error // 다른 네트워크 에러는 그대로 전파
                }
            },
            joinGoal: { goalId in
                func join(with token: String) async throws {
                    let endpoint = try APIEndpoints.joinGoalEndpoint(
                        goalId: goalId,
                        accessToken: token
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    if response.code == "200" {
                        return
                    }
                    guard let code = Int(response.code) else {
                        throw NetworkError.invaildResponse
                    }
                    throw NetworkError.statusCodeError(code: code)
                }
                let token = await dataStorageClient.tokenInfo
                guard let accessToken = token.accessToken
                else { throw LoginError.noToken }
                do {
                    try await join(with: accessToken)
                } catch let error as NetworkError {
                    if case let .statusCodeError(code) = error,
                        code == 401 {
                        // 토큰이 만료된 경우
                        guard let refreshToken = token.refreshToken else {
                            throw LoginError.noToken
                        }
                        // 리프레시 토큰으로 새 액세스 토큰 발급
                        let newToken = try await authClient.refresh(token: refreshToken)
                        // 새 토큰으로 재시도
                        try await join(with: newToken.accessToken)
                    } else {
                        throw error  // 401 이외의 에러는 그대로 전파
                    }
                }
            }
        )
    }

    public static var testValue = MenteeClient(
        login: {},
        fetchMenteeInfo: { FetchMenteeInfoResponseDTO.dummy.data! },
        joinGoal: { _ in }
    )

    public static var previewValue = MenteeClient(
        login: {},
        fetchMenteeInfo: { FetchMenteeInfoResponseDTO.dummy.data! },
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
