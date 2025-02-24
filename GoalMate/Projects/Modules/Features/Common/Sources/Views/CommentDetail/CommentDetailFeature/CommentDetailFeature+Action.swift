//
//  CommentDetailFeature+Action.swift
//  FeatureComment
//
//  Created by Importants on 2/23/25.
//

import ComposableArchitecture
import Data

extension CommentDetailFeature {
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.isLoading = true
            return .send(.feature(.fetchCommentDetail))
        }
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .retryButtonTapped:
            state.isLoading = true
            return .send(.feature(.fetchCommentDetail))
        case .onLoadMore:
            guard state.hasMorePages else { return .none }
            state.isScrollFetching = true
            return .send(.feature(.fetchCommentDetail))
        case .backButtonTapped:
            return .send(.delegate(.closeView))
        case let .showCommentPopup(commentId, position):
            state.input = ""
            state.isShowCommentPopup = .display(commentId, position)
            return .none
        case .dismissCommentPopup:
            state.isShowCommentPopup = .dismiss
            return .none
        case .sendMessageButtonTapped:
            guard state.input.isEmpty == false else { return .none }
            if case let .edit(commentId) = state.isEditMode {
                return .send(.feature(.updateMessage(commentId, state.input)))
            } else {
                return .send(.feature(.submitMessage(state.input)))
            }
        case let .editCommentButtonTapped(commentId):
            state.isEditMode = .edit(commentId)
            state.isShowCommentPopup = .dismiss
            return .none
        case .editCancelButtonTapped:
            state.input = ""
            state.isEditMode = .idle
            return .none
        case let .deleteButtonTapped(commentId):
            state.isShowCommentPopup = .dismiss
            return .send(.feature(.deleteMessage(commentId)))
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .fetchCommentDetail:
            return .run { [currentPage = state.currentPage, roomId = state.roomId] send in
                do {
                    let response = try await menteeClient.fetchCommentDetail(
                        currentPage, roomId
                    )
                    await send(
                        .feature(
                            .checkFetchCommentDetailResponse(
                                .success(
                                    response.comments,
                                    response.page.hasNext ?? false
                                ))
                        )
                    )
                } catch is NetworkError {
                    await send(.feature(
                            .checkFetchCommentDetailResponse(.networkError))
                    )
                } catch {
                    await send(.feature(
                        .checkFetchCommentDetailResponse(.failed)))
                }
            }
        case let .checkFetchCommentDetailResponse(result):
            switch result {
            case let .success(comments, hasNext):
                state.comments += comments
                state.totalCount += comments.count
                state.currentPage += 1
                state.hasMorePages = hasNext
            case .networkError:
                state.didFailToLoad = true
            case .failed:
                break
            }
            state.isLoading = false
            state.isScrollFetching = false
            return .none
        case let .submitMessage(message):
            state.isLoading = true
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
                state.comments.insert(comment, at: 0)
                state.input = ""
            case .limitedsending:
                state.isShowPopup = true
            case .networkError, .failed:
                state.toastState = .display("수정하지 못했습니다.")
            }
            state.isLoading = false
            return .none
        case let .updateMessage(commentId, message):
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
                state.isEditMode = .idle
                state.comments[id: comment.id] = comment
            case .networkError, .failed:
                state.toastState = .display("수정하지 못했습니다.")
            }
            state.isLoading = false
            return .none
        case let .deleteMessage(commentId):
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
                state.comments.remove(id: commentId)
            case .networkError, .failed:
                state.toastState = .display("삭제하지 못했습니다.")
            }
            state.isLoading = false
            return .none
        }
    }

    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
