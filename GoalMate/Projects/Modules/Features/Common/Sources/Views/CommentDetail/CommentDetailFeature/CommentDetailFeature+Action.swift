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
            guard state.hasMorePages else { return .none }
            state.isLoading = true
            return .send(.feature(.fetchCommentDetail))
        }
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .retryButtonTapped, .onLoadMore:
            guard state.hasMorePages else { return .none }
            state.isLoading = true
            return .send(.feature(.fetchCommentDetail))
        case .backButtonTapped:
            return .send(.delegate(.closeView))
        case .sendMessageButtonTapped:
            guard state.input.isEmpty == false else { return .none }
            return .send(.feature(.sendMessage(state.input)))
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case let .sendMessage(message):
            state.isLoading = true
            return .run { [roomId = state.roomId, message] send in
                do {
                    let response = try await menteeClient.postMessage(
                        roomId,
                        message
                    )
                    await send(
                        .feature(.checksendMessageResponse(.success(response)))
                    )
                } catch let error as NetworkError {
                    if case let .statusCodeError(code) = error,
                        code == 409 {
                        await send(
                            .feature(.checkFetchCommentDetailResponse(.limitedsending))
                        )
                        return
                    }
                    await send(
                        .feature(.checkFetchCommentDetailResponse(.networkError))
                    )
                } catch {
                    await send(
                        .feature(.checkFetchCommentDetailResponse(.failed))
                    )
                }
            }
        case let .updateMessage(commentId, message):
            return .run { [roomId = state.roomId, message] send in
                do {
                    
                } catch is NetworkError {
                    
                } catch {
                    
                }
            }
        case let .deleteMessage:
            return .run { [roomId = state.roomId] send in
                do {
                    
                } catch is NetworkError {
                    
                } catch {
                    
                }
            }
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
                    await send(
                        .feature(.checkFetchCommentDetailResponse(.networkError))
                    )
                } catch {
                    await send(
                        .feature(.checkFetchCommentDetailResponse(.failed))
                    )
                }
            }
        case let .checkFetchCommentDetailResponse(result):
            switch result {
            case let .success(comments, hasNext):
                state.comments.insert(contentsOf: comments, at: 0)
                state.totalCount += comments.count
                state.currentPage += 1
                state.hasMorePages = hasNext
            case .networkError:
                state.didFailToLoad = true
            case .failed:
                break
            case .limitedsending:
                state.isShowPopup = true
            }
            state.isLoading = false
            return .none
        case let .checksendMessageResponse(result):
            switch result {
            case let .success(comment):
                state.comments.append(comment)
                state.input = ""
            case .networkError:
                state.didFailToLoad = true
            case .failed:
                break
            }
            state.isLoading = false
            return .none
        case let .checkUpdateMessageResponse(result):
            switch result {
            case let .success(comments):
                break
            case .networkError:
                state.didFailToLoad = true
            case .failed:
                break
            }
            state.isLoading = false
            return .none
        case let .checkDeleteMessageResponse(result):
            switch result {
            case let .success(comments):
                break
            case .networkError:
                state.didFailToLoad = true
            case .failed:
                break
            }
            state.isLoading = false
            return .none
        }
    }

    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
