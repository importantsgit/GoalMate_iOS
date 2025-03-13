//
//  CommentDetailFeature+Action.swift
//  FeatureComment
//
//  Created by Importants on 2/23/25.
//

import ComposableArchitecture
import Data
import Foundation
import Utils

extension CommentDetailFeature {
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.pagingationState = .init()
            state.isLoading = true
            return .send(.feature(.fetchCommentDetail))
        }
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .hideKeyboard:
            return .run { _ in
                await environmentClient.dismissKeyboard()
            }
        case .retryButtonTapped:
            state.isLoading = true
            return .send(.feature(.fetchCommentDetail))
        case .onLoadMore:
            guard state.pagingationState.hasMorePages else { return .none }
            return .send(.feature(.fetchCommentDetail))
        case .backButtonTapped:
            return .send(.delegate(.closeView))
        case .sendMessageButtonTapped:
            guard state.input.isEmpty == false else { return .none }
            if case let .edit(commentId, text) = state.isUpdateMode {
                guard text != state.input else { return .none }
                return .send(.feature(.updateMessage(commentId, state.input)))
            } else {
                return .send(.feature(.submitMessage(state.input)))
            }
        case let .showEditPopup(commentId, position):
            HapticManager.impact(style: .selection)
            state.input = ""
            state.isShowEditPopup = .display(commentId, position)
            return .none
        case .dismissEditPopup:
            state.isShowEditPopup = .dismiss
            return .none
        case let .editCommentButtonTapped(commentId):
            guard let selectComment = state.comments[id: commentId],
                  let text = selectComment.comment
            else { return .none }
            state.input = text
            state.isUpdateMode = .edit(commentId, text)
            state.isShowEditPopup = .dismiss
            return .none
        case .editCancelButtonTapped:
            state.input = ""
            state.isUpdateMode = .idle
            return .send(.view(.hideKeyboard))
        case let .deleteButtonTapped(commentId):
            state.isShowEditPopup = .dismiss
            return .send(.feature(.deleteMessage(commentId)))
        case .showLimitedSendingPopup:
            state.isShowLimitedSendingPopup = true
            return .none
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .fetchCommentDetail:
            state.isScrollFetching = true
            let currentPage = state.pagingationState.currentPage
            let roomId = state.roomId
            return .run { [currentPage, roomId] send in
                do {
                    let response = try await menteeClient.fetchCommentDetail(
                        currentPage, roomId
                    )
                    print("response: \(response)")
                    await send(
                        .feature(
                            .checkFetchCommentDetailResponse(
                                .success(
                                    response.comments,
                                    response.page.hasNext ?? false
                                ))
                        )
                    )
                } catch let error as NetworkError {
                    print("error: \(error)")
                    await send(.feature(
                            .checkFetchCommentDetailResponse(.networkError))
                    )
                } catch {
                    print("error: \(error)")
                    await send(.feature(
                        .checkFetchCommentDetailResponse(.failed)))
                }
            }
        case let .checkFetchCommentDetailResponse(result):
            switch result {
            case let .success(comments, hasNext):
                // 오늘 날짜가 있는 경우 체크
                state.isSentCommentToday = state.pagingationState.currentPage == 1 &&
                comments.contains(where: { comment in
                    guard let date = comment.commentedAt?.toISODate(),
                          Calendar.current.isDateInToday(date)
                    else { return false }
                    return comment.writerRole == .mentee
                })
                state.comments.append(contentsOf: comments)
                state.pagingationState.totalCount += comments.count
                state.pagingationState.currentPage += 1
                state.pagingationState.hasMorePages = hasNext
            case .networkError:
                state.didFailToLoad = true
            case .failed:
                break
            }
            state.isLoading = false
            state.isScrollFetching = false
            return .none
        case let .submitMessage(message):
            state.isMessageProcessing = true
            return .run { [roomId = state.roomId, message] send in
                do {
                    let response = try await menteeClient.postMessage(
                        roomId,
                        message
                    )
                    await send(
                        .feature(
                            .checkSubmitMessageResponse(.success(response)))
                    )
                } catch let error as NetworkError {
                    if case let .statusCodeError(code) = error,
                        code == 409 {
                        await send(
                            .feature(
                                .checkSubmitMessageResponse(.limitedsending))
                        )
                        return
                    }
                    await send(
                        .feature(
                            .checkSubmitMessageResponse(.networkError))
                    )
                } catch {
                    await send(
                        .feature(
                            .checkSubmitMessageResponse(.failed))
                    )
                }
            }
        case let .checkSubmitMessageResponse(result):
            switch result {
            case let .success(comment):
                state.isSentCommentToday = true
                state.comments.insert(comment, at: 0)
                state.input = ""
                state.isMessageProcessing = false
                return .send(.view(.hideKeyboard))
            case .limitedsending:
                state.isShowLimitedSendingPopup = true
            case .networkError, .failed:
                state.toastState = .display("수정하지 못했습니다.")
            }
            state.isMessageProcessing = false
            return .none
        case let .updateMessage(commentId, message):
            state.isMessageProcessing = true
            return .run { [commentId, message] send in
                do {
                    let response = try await menteeClient.updateMessage(
                        commentId: commentId,
                        comment: message
                    )
                    await send(
                        .feature(
                            .checkUpdateMessageResponse(.success(response)))
                    )
                } catch is NetworkError {
                    await send(
                        .feature(
                            .checkUpdateMessageResponse(.networkError))
                    )
                } catch {
                    await send(
                        .feature(
                            .checkUpdateMessageResponse(.failed))
                    )
                }
            }
        case let .checkUpdateMessageResponse(result):
            switch result {
            case let .success(comment):
                state.input = ""
                state.isUpdateMode = .idle
                state.comments[id: comment.id] = comment
                state.isMessageProcessing = false
                return .send(.view(.hideKeyboard))
            case .networkError, .failed:
                state.toastState = .display("수정하지 못했습니다.")
            }
            state.isMessageProcessing = false
            return .none
        case let .deleteMessage(commentId):
            state.isMessageProcessing = true
            return .run { [commentId] send in
                do {
                    try await menteeClient
                        .deleteMessage(commentId: commentId)
                    await send(
                        .feature(
                            .checkDeleteMessageResponse(.success(commentId)))
                    )
                } catch is NetworkError {
                    await send(
                        .feature(
                            .checkDeleteMessageResponse(.networkError))
                    )
                } catch {
                    await send(
                        .feature(
                            .checkDeleteMessageResponse(.failed))
                    )
                }
            }
        case let .checkDeleteMessageResponse(result):
            switch result {
            case let .success(commentId):
                if let comment = state.comments[id: commentId],
                   let commentedAt = comment.commentedAt,
                   let date = commentedAt.toISODate(),
                   Calendar.current.isDateInToday(date) {
                    print(commentedAt, date.ISO8601Format(), date.getString())
                    state.isSentCommentToday = false
                }
                state.comments.remove(id: commentId)
            case .networkError, .failed:
                state.toastState = .display("삭제하지 못했습니다.")
            }
            state.isMessageProcessing = false
            return .none
        }
    }

    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
