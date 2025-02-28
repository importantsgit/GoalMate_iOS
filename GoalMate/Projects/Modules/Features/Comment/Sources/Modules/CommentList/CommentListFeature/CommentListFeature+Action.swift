//
//  CommentListFeature+Action.swift
//  FeatureComment
//
//  Created by Importants on 2/23/25.
//

import ComposableArchitecture
import Data
import Foundation

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
        case .onDisappear:
            state.isLoading = true
            state.isLogin = true
            state.isScrollFetching = false
            state.didFailToLoad = false
            state.commentRoomList = []
            state.pagingationState = .init()
            return .none
        }
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case let .chatRoomButtonTapped(roomId, title, endDate):
            return .send(.delegate(
                .showCommentDetail(roomId, title, endDate)))
        case .onLoadMore:
            guard state.pagingationState.hasMorePages,
                  state.isScrollFetching == false
            else { return .none }
            state.isScrollFetching = true
            return .send(.feature(.fetchCommentRooms))
                .throttle(
                    id: PublisherID.throttle,
                    for: .milliseconds(500),
                    scheduler: DispatchQueue.main,
                    latest: true)
        case .retryButtonTapped:
            state.isLoading = true
            state.didFailToLoad = false
            return .send(.feature(.fetchCommentRooms))
        case .showMoreButtonTapped:
            return .send(.delegate(.showGoalList))
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .fetchCommentRooms:
            return .run { [currentPage = state.pagingationState.currentPage] send in
                do {
                    let response = try await menteeClient.fetchCommentRooms(currentPage)
                    let cellModels = try await withThrowingTaskGroup(of: CommentRoomCell.self) { group in
                        for commentRoom in response.commentRooms {
                            group.addTask {
                                .init(roomInfo: commentRoom)
                            }
                        }
                        var results = [CommentRoomCell]()
                        for try await cellModel in group {
                            results.append(cellModel)
                        }
                        return results.sorted { $0.id < $1.id }
                    }
                    await send(.feature(
                        .checkFetchCommentRoomsResult(
                            .success(
                                cellModels,
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
                state.commentRoomList.append(contentsOf: commentRooms)
                state.pagingationState.totalCount += commentRooms.count
                state.pagingationState.currentPage += 1
                state.pagingationState.hasMorePages = hasNext
            case .networkError, .failed:
                if state.isLoading {
                     state.didFailToLoad = true
                 }
            }
            state.isLoading = false
            state.isScrollFetching = false
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
