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
    public var fetchMenteeInfo: () async throws -> FetchMenteeInfoResponseDTO.Response
    public var joinGoal: (_ goalId: Int) async throws -> Void
    public init(
        fetchMenteeInfo: @escaping () -> FetchMenteeInfoResponseDTO.Response,
        joinGoal: @escaping (_ goalId: Int) async throws -> Void
    ) {
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
        func executeWithTokenValidation<T>(
            action: (_ accessToken: String) async throws -> T
        ) async throws -> T {
            guard let accessToken = await dataStorageClient.tokenInfo.accessToken else {
                throw AuthError.needLogin
            }
            do {
                return try await action(accessToken)
            } catch let error as NetworkError {
                if case let .statusCodeError(code) = error,
                    code == 401 {
                    let newAccessToken = try await authClient.refresh()
                    return try await action(newAccessToken)
                }
                throw error
            }
        }
        return .init(
            fetchMenteeInfo: {
                try await executeWithTokenValidation { accessToken in
                    let endpoint = try APIEndpoints.fetchMenteeInfoEndpoint(
                        accessToken: accessToken
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    guard let data = response.data
                    else { throw NetworkError.emptyData }
                    return data
                }
            },
            joinGoal: { goalId in
                try await executeWithTokenValidation { accessToken in
                    let endpoint = try APIEndpoints.joinGoalEndpoint(
                        goalId: goalId,
                        accessToken: accessToken
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
            }
        )
    }

    public static var testValue = MenteeClient(
        fetchMenteeInfo: { FetchMenteeInfoResponseDTO.dummy.data! },
        joinGoal: { _ in }
    )

    public static var previewValue = MenteeClient(
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
