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
    public var fetchMyGoals: (_ page: Int) async throws -> FetchMyGoalsResponseDTO.Response
    public var fetchMyGoalDetail: (
        _ menteeGoalId: Int,
        _ date: String
    ) async throws -> FetchMyGoalDetailResponseDTO.Response
    public var fetchWeeklyProgress: (
        _ menteeGoalId: Int,
        _ date: String
    ) async throws -> FetchWeeklyProgressResponseDTO.Response
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
            guard let accessToken = await dataStorageClient.tokenInfo.accessToken
            else { throw AuthError.needLogin }
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
            },
            fetchMyGoals: { page in
                try await executeWithTokenValidation { accessToken in
                    let requestDTO = PaginationRequestDTO(
                        page: page, size: 10
                    )
                    let endpoint = APIEndpoints.fetchMyGoalsEndpoint(
                        with: requestDTO,
                        accessToken: accessToken
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    guard let data = response.data
                    else { throw NetworkError.emptyData }
                    return data
                }
            },
            fetchMyGoalDetail: { menteeGoalId, date in
                try await executeWithTokenValidation { accessToken in
                    let endpoint = try APIEndpoints.fetchMyGoalDetailEndpoint(
                        menteeGoalId: menteeGoalId,
                        date: date,
                        accessToken: accessToken
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    guard let data = response.data
                    else { throw NetworkError.emptyData }
                    return data
                }
                
            },
            fetchWeeklyProgress: { menteeGoalId, date in
                try await executeWithTokenValidation { accessToken in
                    let endpoint = try APIEndpoints.fetchWeeklyProgressEndpoint(
                        menteeGoalId: menteeGoalId,
                        date: date,
                        accessToken: accessToken
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    guard let data = response.data
                    else { throw NetworkError.emptyData }
                    return data
                }
            }
        )
    }
    
    public static var testValue = MenteeClient(
        fetchMenteeInfo: { FetchMenteeInfoResponseDTO.dummy.data! },
        joinGoal: { _ in },
        fetchMyGoals: { _ in
            FetchMyGoalsResponseDTO.dummy.data!
        },
        fetchMyGoalDetail: { _, _ in
            FetchMyGoalDetailResponseDTO.dummy.data!
        },
        fetchWeeklyProgress: { _, _ in FetchWeeklyProgressResponseDTO.dummy.data!
        }
    )
    
    public static var previewValue = MenteeClient(
        fetchMenteeInfo: { FetchMenteeInfoResponseDTO.dummy.data! },
        joinGoal: { _ in },
        fetchMyGoals: { _ in
            FetchMyGoalsResponseDTO.dummy.data!
        },
        fetchMyGoalDetail: { _, _ in
            FetchMyGoalDetailResponseDTO.dummy.data!
        },
        fetchWeeklyProgress: { _, _ in FetchWeeklyProgressResponseDTO.dummy.data!
        }
    )
}

// MARK: - Dependencies Registration
extension DependencyValues {
    public var menteeClient: MenteeClient {
        get { self[MenteeClient.self] }
        set { self[MenteeClient.self] = newValue }
    }
}
