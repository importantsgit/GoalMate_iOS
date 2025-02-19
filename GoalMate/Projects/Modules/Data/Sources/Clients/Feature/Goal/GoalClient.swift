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
                    size: 20
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
        fetchGoals: { page in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            let startId = (page - 1) * 20 + 1
            return .init(
                goals: (0..<20).map { index in
                    let id = startId + index
                    return .init(
                        id: id,
                        title: "목표 #\(id)",
                        topic: "주제 #\(id)",
                        description: "설명 #\(id)",
                        period: 30,
                        dailyDuration: 60,
                        participantsLimit: 100,
                        currentParticipants: id * 3,
                        isClosingSoon: id % 2 == 0,
                        goalStatus: [.upcoming, .open].randomElement()!,
                        mentorName: "멘토 #\(id)",
                        createdAt: "2025-01-01",
                        updatedAt: "2025-02-19",
                        mainImage: "https://example.com/image-\(id).jpg"
                    )
                },
                page: .init(
                    totalElements: 50, // 전체 데이터 수
                    totalPages: 100,     // 전체 페이지 수
                    currentPage: page,
                    pageSize: 10,
                    nextPage: page < 5 ? page + 1 : nil,
                    prevPage: page > 1 ? page - 1 : nil,
                    hasNext: page < 5,
                    hasPrev: page > 1
                )
            )
        },
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
