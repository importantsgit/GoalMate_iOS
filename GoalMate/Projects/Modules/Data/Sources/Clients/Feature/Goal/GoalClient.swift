//
//  GoalClient.swift
//  Data
//
//  Created by Importants on 2/15/25.
//

import Dependencies
import DependenciesMacros
import Foundation
import Utils

@DependencyClient
public struct GoalClient {
    public var fetchGoals: (
        _ page: Int
    ) async throws -> FetchGoalsResponseDTO.Response
    public var fetchGoalDetail: (
        _ goalId: Int
    ) async throws -> FetchGoalDetailResponseDTO.Response
    init(
        fetchGoals: @escaping (
            _ page: Int
        ) -> FetchGoalsResponseDTO.Response,
        fetchGoalDetail: @escaping (
            _ goalId: Int
        ) -> FetchGoalDetailResponseDTO.Response
    ) {
        self.fetchGoals = fetchGoals
        self.fetchGoalDetail = fetchGoalDetail
    }
}

// MARK: - Live Implementation
extension GoalClient: DependencyKey {
    public static var liveValue: GoalClient {
        @Dependency(\.dataStorageClient) var dataStorageClient
        @Dependency(\.networkClient) var networkClient
        @Dependency(\.authClient) var authClient
        return .init(
            fetchGoals: { page in
                let requestDTO: PaginationRequestDTO = .init(
                    page: page,
                    size: 10
                )
                let endpoint = APIEndpoints.fetchGoalEndpoint(
                    with: requestDTO
                )
                let response = try await networkClient.asyncRequest(with: endpoint)
                guard let data = response.data
                else { throw NetworkError.emptyData }
                return data
            },
            fetchGoalDetail: { goalId in
                let endPoint = try APIEndpoints.fetchGoalDetailEndpoint(goalId: goalId)
                let response = try await networkClient.asyncRequest(with: endPoint)
                guard let data = response.data
                else { throw NetworkError.emptyData }
                return data
            }
        )
    }

    public static var testValue = GoalClient(
        fetchGoals: { _ in FetchGoalsResponseDTO.dummyList.data! },
        fetchGoalDetail: { _ in FetchGoalDetailResponseDTO.dummy.data! }
    )

    public static var previewValue = GoalClient(
        fetchGoals: { _ in FetchGoalsResponseDTO.dummyList.data! },
        fetchGoalDetail: { _ in FetchGoalDetailResponseDTO.dummy.data! }
    )
}

// MARK: - Dependencies Registration
extension DependencyValues {
    public var goalClient: GoalClient {
        get { self[GoalClient.self] }
        set { self[GoalClient.self] = newValue }
    }
}
