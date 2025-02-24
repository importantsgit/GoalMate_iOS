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
        var isShowCommentPopup: CommentPopupState
        var isEditMode: EditCommentState
        var isEditingComment: Bool
        var totalCount: Int
        var currentPage: Int
        var hasMorePages: Bool
        var toastState: ToastState
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
            self.isShowCommentPopup = .dismiss
            self.isEditingComment = false
            self.isEditMode = .idle
            self.toastState = .hide
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
        case showCommentPopup(Int, Position)
        case dismissCommentPopup
        case editCommentButtonTapped(Int)
        case editCancelButtonTapped
        case deleteButtonTapped(Int)
    }
    public enum FeatureAction {
        case fetchCommentDetail
        case checkFetchCommentDetailResponse(FetchComentDetailResult)
        case submitMessage(String)
        case checkSubmitMessageResponse(SubmitMessageResult)
        case updateMessage(Int, String)
        case checkUpdateMessageResponse(UpdateMessageResult)
        case deleteMessage(Int)
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
                guard text.count < 300
                else { return .none }
                    state.input = text
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
    case networkError
    case failed
    }
    public enum SubmitMessageResult {
        case success(CommentContent)
        case limitedsending
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
    public enum Position: Equatable {
        case top(CGFloat)
        case bottom(CGFloat)
        public static func == (
            lhs: Position,
            rhs: Position) -> Bool {
                switch (lhs, rhs) {
                case (.top, .top), (.bottom, .bottom):
                    return true
                default:
                    return false
                }
        }
    }
    public enum CommentPopupState: Equatable {
        case display(Int, Position)
        case dismiss
        public static func == (
            lhs: CommentPopupState,
            rhs: CommentPopupState) -> Bool {
                switch (lhs, rhs) {
                case (.display, .display), (.dismiss, .dismiss):
                    return true
                default:
                    return false
                }
        }
    }
    public enum EditCommentState: Equatable {
        case edit(Int)
        case idle
        public static func == (
            lhs: EditCommentState,
            rhs: EditCommentState) -> Bool {
                switch (lhs, rhs) {
                case (.edit, .edit), (.idle, .idle):
                    return true
                default:
                    return false
                }
        }
    }
}
