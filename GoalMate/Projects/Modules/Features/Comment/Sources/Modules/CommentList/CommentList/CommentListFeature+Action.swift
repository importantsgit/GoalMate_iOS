//
//  CommentListFeature+Action.swift
//  FeatureComment
//
//  Created by Importants on 2/23/25.
//

import ComposableArchitecture
import Data

extension CommentListFeature {
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .run { send in
                guard try await authClient.checkLoginStatus()
                else {
                    print("Login Failed")
                    await send(.feature(.loginFailed))
                    return
                }
                await send(.feature(.fetchCommentRooms))
            }
        }
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case let .chatRoomButtonTapped(roomId, title, startDate):
            return .send(.delegate(
                .showCommentDetail(roomId, title, startDate)))
        case .retryButtonTapped, .onLoadMore:
            guard state.hasMorePages else { return .none }
            state.isLoading = true
            return .run { send in
                await send(.feature(.fetchCommentRooms))
            }
        case .showMoreButtonTapped:
            return .send(.delegate(.showGoalList))
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .fetchCommentRooms:
            return .run { [currentPage = state.currentPage] send in
                do {
                    print("run")
                    let response = try await menteeClient.fetchCommentRooms(currentPage)
                    await send(.feature(
                        .checkFetchCommentRoomsResult(
                            .success(
                                response.commentRooms,
                                response.page.hasNext ?? false))))
                } catch is NetworkError {
                    await send(.feature(
                        .checkFetchCommentRoomsResult(.networkError)))
                } catch {
                    await send(.feature(
                        .checkFetchCommentRoomsResult(.failed)))
                }
            }
        case let .checkFetchCommentRoomsResult(result):
            switch result {
            case let .success(commentRooms, hasNext):
                state.commentRoomList += commentRooms
                state.totalCount += commentRooms.count
                state.currentPage += 1
                state.hasMorePages = hasNext
            case .networkError:
                state.didFailToLoad = true
            case .failed:
                break
            }
            state.isLoading = false
            return .none
        case .loginFailed:
            state.isLogin = false
            state.isLoading = false
            return .none
        }
    }
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
