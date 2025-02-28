//
//  CommentListFeature.swift
//  FeatureComment
//
//  Created by Importants on 2/23/25.
//

import ComposableArchitecture
import Data
import FeatureCommon
import Foundation

@Reducer
public struct CommentListFeature {
    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        public var isLoading: Bool
        var isScrollFetching: Bool
        var didFailToLoad: Bool
        var isLogin: Bool
        var toastState: ToastState
        var pagingationState: PaginationState
        var commentRoomList: IdentifiedArrayOf<CommentRoomCell>
        public init() {
            self.id = UUID()
            self.isLoading = true
            self.isScrollFetching = false
            self.didFailToLoad = false
            self.isLogin = true
            self.toastState = .hide
            self.commentRoomList = []
            self.pagingationState = .init()
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {
        case onAppear
        case onDisappear
    }
    public enum ViewAction {
        case chatRoomButtonTapped(Int, String?, String?)
        case retryButtonTapped
        case showMoreButtonTapped
        case onLoadMore
    }
    public enum FeatureAction {
        case fetchCommentRooms
        case checkFetchCommentRoomsResult(FetchCommentRoomResult)
        case loginFailed
    }
    public enum DelegateAction {
        case showCommentDetail(Int, String?, String?)
        case showGoalList
    }
    @Dependency(\.authClient) var authClient
    @Dependency(\.menteeClient) var menteeClient
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .viewCycling(action):
                return reduce(into: &state, action: action)
            case let .view(action):
                return reduce(into: &state, action: action)
            case let .feature(action):
                return reduce(into: &state, action: action)
            case let .delegate(action):
                return reduce(into: &state, action: action)
            case .binding:
                return .none
            }
        }
    }
}

extension CommentListFeature {
    public enum PublisherID {
        case throttle
    }
    public enum FetchCommentRoomResult {
    case success([CommentRoomCell], Bool)
    case networkError
    case failed
    }
}
