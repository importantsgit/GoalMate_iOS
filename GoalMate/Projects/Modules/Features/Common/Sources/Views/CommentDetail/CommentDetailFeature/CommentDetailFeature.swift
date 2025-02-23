//
//  CommentDetailFeature.swift
//  FeatureComment
//
//  Created by Importants on 2/23/25.
//

import ComposableArchitecture
import Data
import Foundation

@Reducer
public struct CommentDetailFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        let roomId: Int
        let title: String
        let startDate: Date
        var isLoading: Bool
        var isScrollFetching: Bool
        var didFailToLoad: Bool
        var input: String = ""
        var isShowPopup: Bool

        var totalCount: Int
        var currentPage: Int
        var hasMorePages: Bool
        var comments: IdentifiedArrayOf<CommentContent>
        public init(
            roomId: Int,
            title: String?,
            startDate: String?
        ) {
            self.id = UUID()
            self.roomId = roomId
            self.title = title ?? "목표"
            self.isLoading = true
            self.isScrollFetching = false
            self.didFailToLoad = false
            self.isShowPopup = false
            self.totalCount = 0
            self.currentPage = 1
            self.hasMorePages = true
            self.comments = []
            if let startDate {
                let date = startDate.toDate(
                    format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                )
                self.startDate = date
            } else {
                self.startDate = Date()
            }

        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
        case inputText(String)
        case dismissPopup(Bool)
    }
    public enum ViewCyclingAction {
        case onAppear
    }
    public enum ViewAction {
        case onLoadMore
        case retryButtonTapped
        case backButtonTapped
        case sendMessageButtonTapped
    }
    public enum FeatureAction {
        case sendMessage(String)
        case updateMessage(Int, String)
        case deleteMessage
        case fetchCommentDetail
        case checkFetchCommentDetailResponse(FetchComentDetailResult)
        case checkUpdateMessageResponse(UpdateMessageResult)
        case checksendMessageResponse(SendMessageResult)
        case checkDeleteMessageResponse(DeleteMessageResult)
    }
    public enum DelegateAction {
        case closeView
    }
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
            case let .inputText(text):
                if text.count < 300 {
                    state.input = text
                }
                return .none
            case let .dismissPopup(isShow):
                state.isShowPopup = isShow
                return .none
            case .binding:
                return .none
            }
        }
    }
}

extension CommentDetailFeature {
    public enum FetchComentDetailResult {
    case success([CommentContent], Bool)
    case limitedsending
    case networkError
    case failed
    }
    public enum SendMessageResult {
        case success(CommentContent)
        case networkError
        case failed
    }
    public enum UpdateMessageResult {
        case success(CommentContent)
        case networkError
        case failed
    }
    public enum DeleteMessageResult {
        case success(Int)
        case networkError
        case failed
    }
}
