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
    public var setNickname: (String) async throws -> Void
    public var isUniqueNickname: (String) async throws -> Bool
    public var fetchMenteeInfo: () async throws -> FetchMenteeInfoResponseDTO.Response
    public var joinGoal: (_ goalId: Int) async throws -> JoinGoalInfo
    public var hasRemainingTodos: () async throws -> Bool
    public var getNewCommentsCount: () async throws -> Int
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
    ) async throws -> FecthCommentRoomsResponseDTO
    public var fetchCommentDetail: (
        _ page: Int,
        _ roomId: Int
    ) async throws -> FetchCommentDetailResponseDTO
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
            setNickname: { nickname in
                try await executeWithTokenValidation { accessToken in
                    let requestDTO = SetNicknameRequestDTO(name: nickname)
                    let endpoint = APIEndpoints.setNicknameEndpoint(
                        with: requestDTO,
                        accessToken: accessToken
                    )
                    let result = try await networkClient.asyncRequest(with: endpoint)
                    await dataStorageClient.setUserInfo(
                        .init(nickname: nickname)
                    )
                }
            },
            isUniqueNickname: { nickname in
                try await executeWithTokenValidation { accessToken in
                    let requestDTO = CheckNicknameRequestDTO(name: nickname)
                    let endpoint = APIEndpoints.checkNicknameEndpoint(
                        with: requestDTO,
                        accessToken: accessToken
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    guard let data = response.data
                    else { throw NetworkError.emptyData }
                    return data.isAvailable
                }
            },
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
                    let code = response.code
                    guard code == "200"
                    else {
                        let code = Int(code.dropFirst()) ?? 0
                        throw NetworkError.statusCodeError(code: code)
                    }
                    guard let info = response.data
                    else { throw NetworkError.invaildResponse }
                    return info
                }
            },
            hasRemainingTodos: {
                return try await executeWithTokenValidation { accessToken in
                    let endpoint = APIEndpoints.checkTodosEndpoint(
                        accessToken: accessToken)
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    guard let data = response.data
                    else { throw NetworkError.emptyData }
                    return data.hasRemainingTodosToday
                }
            },
            getNewCommentsCount: {
                try await executeWithTokenValidation { accessToken in
                    let endpoint = APIEndpoints.getNewCommentsCount(
                        accessToken: accessToken
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    guard let data = response.data
                    else { throw NetworkError.emptyData }
                    return data.newCommentsCount
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
        setNickname: { _ in return },
        isUniqueNickname: { _ in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return true
        },
        fetchMenteeInfo: { FetchMenteeInfoResponseDTO.dummy.data!
        },
        joinGoal: { _ in
            return .init(menteeGoalId: 0, commentRoomId: 0)
        },
        hasRemainingTodos: {
            return true
        },
        getNewCommentsCount: {
            return 4
        },
        fetchMyGoals: { _ in
            FetchMyGoalsResponseDTO.dummy.data!
        },
        fetchMyGoalDetail: { _, _ in
            FetchMyGoalDetailResponseDTO.dummy.data!
        },
        fetchWeeklyProgress: { _, _ in FetchWeeklyProgressResponseDTO.dummy.data!
        },
        updateTodo: { _, _, status in
            var dummy = Todo.dummy
            dummy.todoStatus = status == .completed ? .todo : .completed
            return dummy
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
            setNickname: { _ in return },
            isUniqueNickname: { _ in
                try await Task.sleep(nanoseconds: 1_000_000_000)
                return true
            },
            fetchMenteeInfo: {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                return FetchMenteeInfoResponseDTO.dummy.data!
            },
            joinGoal: { _ in
                return .init(menteeGoalId: 0, commentRoomId: 0)
            },
            hasRemainingTodos: {
                return true
            },
            getNewCommentsCount: {
                return 4
            },
            fetchMyGoals: { page in
                try await Task.sleep(nanoseconds: 2_000_000_000)
                let startId = (page - 1) * 20 + 1
                return FetchMyGoalsResponseDTO.Response.init(
                    menteeGoals: (0..<20).map { index in
                        let id = startId + index
                        return .init(
                            id: id,
                            goalId: id,
                            commentRoomId: 1000 + id, title: "목표 #\(id)",
                            topic: "주제 #\(id)",
                            mentorName: "멘토 #\(id)",
                            mainImage: "https://example.com/image-\(id).jpg",
                            startDate: "2025-01-01",
                            endDate: "2025-12-31",
                            mentorLetter: "멘토레터 #\(id)", // finalComment 대신 mentorLetter로 변경
                            todayTodoCount: 5,
                            todayCompletedCount: 3,
                            todayRemainingCount: (0...5).randomElement()!,
                            totalTodoCount: 100,
                            totalCompletedCount: id * 5, // 진행도를 다르게 보여주기 위해
                            menteeGoalStatus: [.inProgress, .completed].randomElement()!,
                            createdAt: "2025-01-01",
                            updatedAt: "2025-02-19" // 누락된 필드 추가
                        )
                    },
                    page: .init(
                        totalElements: 50, // 전체 데이터 수
                        totalPages: 100,   // 전체 페이지 수
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
                let startId = (page - 1) * 20 + 1
                return .init(
                    commentRooms: (0..<20).map { index in
                        let id = startId + index
                        return CommentRoom(
                            id: id,
                            menteeGoalId: id + 100,
                            menteeGoalTitle: "목표 제목 #\(id)",
                            startDate: "2025-01-\(String(format: "%02d", id % 28 + 1))",
                            endDate: "2025-03-\(String(format: "%02d", id % 28 + 1))",
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
                let calendar = Calendar.current
                let today = Date()
                return .init(
                    comments: (0..<20).map { index in
                        let id = startId + index + 1
                        let isEven = id % 2 == 0
                        let dateId = id / 2
                        let date = calendar.date(byAdding: .day, value: -dateId, to: today)!
                        let koreanDateFormatter = DateFormatter()
                        koreanDateFormatter.locale = Locale(identifier: "ko_KR")
                        koreanDateFormatter.dateFormat = "yyyy년 MM월 dd일"
                        let koreanDateString = koreanDateFormatter.string(from: date)
                        // ISO8601 포맷으로 변환 (API 응답용)
                        let dateFormatter = ISO8601DateFormatter()
                        dateFormatter.formatOptions = [
                            .withInternetDateTime, .withFractionalSeconds]
                        let dateString = dateFormatter.string(from: date)
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
