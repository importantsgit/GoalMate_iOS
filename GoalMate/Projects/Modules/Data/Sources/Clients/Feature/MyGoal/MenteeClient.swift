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
    public var updateTodo: (
        _ menteeGoalId: Int,
        _ todoId: Int,
        _ status: TodoStatus
    ) async throws -> Todo
    public var fetchCommentRooms: (
        _ page: Int
    ) async throws -> FecthCommentRoomsResponseDTO.Response
    public var fetchCommentDetail: (
        _ page: Int,
        _ roomId: Int
    ) async throws -> FetchCommentDetailResponseDTO.Response
    public var postMessage: (
        _ roomId: Int,
        _ comment: String
    ) async throws -> CommentContent
    public var updateMessage: (
        _ commentId: Int,
        _ comment: String
    ) async throws -> CommentContent
    public var deleteMessage: (_ commentId: Int) async throws -> Void
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
                    print(response)
                    guard let code = Int(response.code) else {
                        throw NetworkError.invaildResponse
                    }
                    throw NetworkError.statusCodeError(code: code)
                }
            },
            fetchMyGoals: { page in
                try await executeWithTokenValidation { accessToken in
                    let requestDTO = PaginationRequestDTO(
                        page: page, size: 20
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
            },
            updateTodo: { menteeGoalId, todoId, status in
                try await executeWithTokenValidation { accessToken in
                    let  requestDTO = PatchTodoRequestDTO(
                        todoStatus: status
                    )
                    let endpoint = try APIEndpoints.patchMenteeTodo(
                        with: requestDTO,
                        menteeGoalId: menteeGoalId,
                        todoId: todoId,
                        accessToken: accessToken
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    guard let data = response.data
                    else { throw NetworkError.emptyData }
                    return data
                }
            },
            fetchCommentRooms: { page in
                try await executeWithTokenValidation { accessToken in
                    let requestDTO = PaginationRequestDTO(
                        page: page,
                        size: 20
                    )
                    let endpoint = APIEndpoints.fetchCommentRooms(
                        with: requestDTO,
                        accessToken: accessToken
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    guard let data = response.data
                    else { throw NetworkError.emptyData }
                    return data
                }
            },
            fetchCommentDetail: { page, roomId in
                try await executeWithTokenValidation { accessToken in
                    let requestDTO = PaginationRequestDTO(
                        page: page,
                        size: 20
                    )
                    let endpoint = try APIEndpoints.fetchComentDetil(
                        with: requestDTO,
                        roomId: roomId,
                        accessToken: accessToken
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    guard let data = response.data
                    else { throw NetworkError.emptyData }
                    return data
                }
            },
            postMessage: { roomId, comment in
                try await executeWithTokenValidation { accessToken in
                    let endpoint = try APIEndpoints.postComentDetil(
                        roomId: roomId,
                        comment: comment,
                        accessToken: accessToken
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    return response.data
                }
            },
            updateMessage: { commentId, comment in
                try await executeWithTokenValidation { accessToken in
                    let endpoint = try APIEndpoints.updateComment(
                        commentId: commentId,
                        comment: comment,
                        accessToken: accessToken
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    return response.data
                }
            },
            deleteMessage: { commentId in
                try await executeWithTokenValidation { accessToken in
                    let endpoint = try APIEndpoints.deleteComment(
                        commentId: commentId,
                        accessToken: accessToken
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    guard "200" == response.code
                    else { throw NetworkError.invaildResponse }
                    return
                }
            }
        )
    }

    public static var testValue = MenteeClient(
        fetchMenteeInfo: { FetchMenteeInfoResponseDTO.dummy.data!
        },
        joinGoal: { _ in },
        fetchMyGoals: { _ in
            FetchMyGoalsResponseDTO.dummy.data!
        },
        fetchMyGoalDetail: { _, _ in
            FetchMyGoalDetailResponseDTO.dummy.data!
        },
        fetchWeeklyProgress: { _, _ in FetchWeeklyProgressResponseDTO.dummy.data!
        },
        updateTodo: { _, _, status in
            return Todo.dummy
        },
        fetchCommentRooms: { page in
            let startId = (page - 1) * 20 + 1
            return .init(
                commentRooms: (0..<20).map { index in
                    let id = startId + index
                    return CommentRoom(
                        id: id,
                        menteeGoalId: id + 100,
                        menteeGoalTitle: "목표 제목 #\(id)",
                        startDate: "2025-01-\(String(format: "%02d", id % 28 + 1))",
                        endDate: "2025-02-\(String(format: "%02d", id % 28 + 1))",
                        menteeName: "멘티 #\(id)",
                        mentorName: "멘토 #\(id)",
                        mentorProfileImage: "https://example.com/profile-\(id).jpg",
                        newCommentsCount: Int.random(in: 0...5)
                    )
                },
                page: .init(
                    totalElements: 123,
                    totalPages: 13,
                    currentPage: page,
                    pageSize: 10,
                    nextPage: page < 13 ? page + 1 : page,
                    prevPage: page > 1 ? page - 1 : page,
                    hasNext: page < 13,
                    hasPrev: page > 1
                )
            )
        },
        fetchCommentDetail: { page, _ in
            let startId = (page - 1) * 20 + 1
            
            return .init(
                comments: (0..<20).map { index in
                    let id = startId + index
                    let isEven = id % 2 == 0
                    return CommentContent(
                        id: id,
                        comment: "안녕하세요 #\(id) 영어 단어 암기는 이렇게 하시면 될 것 같아요! 좋은 하루 보내세요 :)",
                        commentedAt: "2025-02-\(String(format: "%02d", id % 28 + 1))T01:00:00.000Z",
                        writer: isEven ? "ANNA" : "USER",
                        writerRole: isEven ? .mentor : .mentee
                    )
                },
                page: .init(
                    totalElements: 123,
                    totalPages: 13,
                    currentPage: page,
                    pageSize: 10,
                    nextPage: page < 13 ? page + 1 : page,
                    prevPage: page > 1 ? page - 1 : page,
                    hasNext: page < 13,
                    hasPrev: page > 1
                )
            )
        },
        postMessage: { _, comment in
            return .init(
                id: 100001,
                comment: comment,
                commentedAt: "2025-02-22T17:52:07.898Z",
                writer: "",
                writerRole: .mentee
            )
        },
        updateMessage: { commentId, comment in
            return .init(
                id: commentId,
                comment: comment,
                commentedAt: "2025-02-22T17:52:07.898Z",
                writer: "sd",
                writerRole: .mentee
            )
        },
        deleteMessage: { commentId in }
    )

    public static var previewValue: MenteeClient = {
        func generateRandomRepeatedText(baseText: String) -> String {
            let repeatCount = Int.random(in: 0...3)
            if repeatCount == 0 { return baseText }
            
            // 텍스트를 반복하여 연결
            var resultText = ""
            for index in 0..<repeatCount {
                resultText += baseText
                if index < repeatCount - 1 {
                    resultText += "\n\n"
                }
            }
            return resultText
        }
        return .init(
            fetchMenteeInfo: {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                return FetchMenteeInfoResponseDTO.dummy.data!
            },
            joinGoal: { _ in },
            fetchMyGoals: { page in
                try await Task.sleep(nanoseconds: 2_000_000_000)
                let startId = (page - 1) * 20 + 1
                return FetchMyGoalsResponseDTO.Response.init(
                    menteeGoals: (0..<20).map { index in
                        let id = startId + index
                        return FetchMyGoalsResponseDTO.Response.MenteeGoal(
                            id: id,
                            title: "목표 #\(id)",
                            topic: "주제 #\(id)",
                            mentorName: "멘토 #\(id)",
                            mainImage: "https://example.com/image-\(id).jpg",
                            startDate: "2025-01-01",
                            endDate: "2025-12-31",
                            finalComment: nil,
                            todayTodoCount: 5,
                            todayCompletedCount: 3,
                            todayRemainingCount: 2,
                            totalTodoCount: 100,
                            totalCompletedCount: id * 5, // 진행도를 다르게 보여주기 위해
                            menteeGoalStatus: [.inProgress, .completed].randomElement()!,
                            createdAt: "2025-01-01",
                            updatedAt: "2025-02-19"
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
            fetchMyGoalDetail: { _, _ in
                try await Task.sleep(nanoseconds: 4_000_000_000)
                return FetchMyGoalDetailResponseDTO.dummy.data!
            },
            fetchWeeklyProgress: { _, _ in
                try await Task.sleep(nanoseconds: 2_000_000_000)
                return FetchWeeklyProgressResponseDTO.dummy.data!
            },
            updateTodo: { _, todoId, status in
                try await Task.sleep(nanoseconds: 2_000_000_000)
                return .init(
                    id: todoId,
                    todoDate: nil,
                    estimatedMinutes: 50,
                    description: "hello",
                    mentorTip: "hello",
                    todoStatus: status == .completed ? .todo : .completed
                )
            },
            fetchCommentRooms: { page in
                let startId = (page - 1) * 10 + 1
                return .init(
                    commentRooms: (0..<10).map { index in
                        let id = startId + index
                        return CommentRoom(
                            id: id,
                            menteeGoalId: id + 100,
                            menteeGoalTitle: "목표 제목 #\(id)",
                            startDate: "2025-01-\(String(format: "%02d", id % 28 + 1))",
                            endDate: "2025-02-\(String(format: "%02d", id % 28 + 1))",
                            menteeName: "멘티 #\(id)",
                            mentorName: "멘토 #\(id)",
                            mentorProfileImage: "https://example.com/profile-\(id).jpg",
                            newCommentsCount: Int.random(in: 0...5)
                        )
                    },
                    page: .init(
                        totalElements: 123,
                        totalPages: 13,
                        currentPage: page,
                        pageSize: 10,
                        nextPage: page < 13 ? page + 1 : page,
                        prevPage: page > 1 ? page - 1 : page,
                        hasNext: page < 13,
                        hasPrev: page > 1
                    )
                )
            },
            fetchCommentDetail: { page, _ in
                let startId = 20 * (page - 1)
                
                // 현재 날짜 기준으로 계산
                let calendar = Calendar.current
                let today = Date()
                
                return .init(
                    comments: (0..<20).map { index in
                        let id = startId + index + 1
                        let isEven = id % 2 == 0
                        
                        // 날짜를 계산할 때 id 대신 id/2를 사용하여
                        // 연속된 두 개의 메시지(멘티/멘토)가 같은 날짜를 가지도록 함
                        let dateId = id / 2
                        let date = calendar.date(byAdding: .day, value: -dateId, to: today)!
                        
                        // 텍스트에 표시할 날짜 형식
                        let koreanDateFormatter = DateFormatter()
                        koreanDateFormatter.locale = Locale(identifier: "ko_KR")
                        koreanDateFormatter.dateFormat = "yyyy년 MM월 dd일"
                        let koreanDateString = koreanDateFormatter.string(from: date)
                        
                        // ISO8601 포맷으로 변환 (API 응답용)
                        let dateFormatter = ISO8601DateFormatter()
                        dateFormatter.formatOptions = [
                            .withInternetDateTime, .withFractionalSeconds]
                        let dateString = dateFormatter.string(from: date)
                        
                        // 텍스트에 날짜 포함
                        let commentText = "안녕하세요 #\(id) [\(koreanDateString)] 영어 단어 암기는 이렇게 하시면 될 것 같아요! 좋은 하루 보내세요 :)"
                        
                        return CommentContent(
                            id: id,
                            comment: generateRandomRepeatedText(baseText: commentText),
                            commentedAt: dateString,
                            writer: isEven ? "ANNA" : "USER",
                            writerRole: isEven ? .mentor : .mentee
                        )
                    },
                    page: .init(
                        totalElements: 400,
                        totalPages: 20,
                        currentPage: page,
                        pageSize: 10,
                        nextPage: page < 20 ? page + 1 : page,
                        prevPage: page > 1 ? page - 1 : page,
                        hasNext: page < 20,
                        hasPrev: page > 1
                    )
                )
            },
            postMessage: { _, comment in
                return .init(
                    id: 100001,
                    comment: comment,
                    commentedAt: "2025-02-22T17:52:07.898Z",
                    writer: "",
                    writerRole: .mentee
                )
            },
            updateMessage: { commentId, comment in
                return .init(
                    id: commentId,
                    comment: comment,
                    commentedAt: "2025-02-22T17:52:07.898Z",
                    writer: "sd",
                    writerRole: .mentee
                )
            },
            deleteMessage: { commentId in }
            )
    }()
}

// MARK: - Dependencies Registration
extension DependencyValues {
    public var menteeClient: MenteeClient {
        get { self[MenteeClient.self] }
        set { self[MenteeClient.self] = newValue }
    }
}
