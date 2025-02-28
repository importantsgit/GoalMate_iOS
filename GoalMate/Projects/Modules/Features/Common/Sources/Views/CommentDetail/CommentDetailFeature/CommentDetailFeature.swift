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
        let endDate: Date
        var isLoading: Bool
        var isScrollFetching: Bool
        var isShowPopup: Bool
        var isUpdatingComment: Bool
        var isMessageProcessing: Bool
        var didFailToLoad: Bool
        var input: String = ""
        var isShowEditPopup: EditPopupState
        var isUpdateMode: UpdateCommentState
        var pagingationState: PaginationState
        var toastState: ToastState
        var comments: IdentifiedArrayOf<CommentContent>
        public init(
            roomId: Int,
            title: String?,
            endDate: String?
        ) {
            self.id = UUID()
            self.roomId = roomId
            self.title = title ?? "목표"
            self.isLoading = true
            self.isScrollFetching = false
            self.didFailToLoad = false
            self.isShowPopup = false
            self.pagingationState = .init()
            self.comments = []
            self.isShowEditPopup = .dismiss
            self.isUpdatingComment = false
            self.isUpdateMode = .idle
            self.toastState = .hide
            self.isMessageProcessing = false
            if let endDate {
                let date = endDate.toDate(
                    format: "yyyy-MM-dd"
                )
                self.endDate = date
            } else {
                self.endDate = Date()
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
        case showEditPopup(Int, Position)
        case dismissEditPopup
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
                let limitedText = String(text.prefix(300))
                state.input = limitedText
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
    public enum EditPopupState: Equatable {
        case display(Int, Position)
        case dismiss
        public static func == (
            lhs: EditPopupState,
            rhs: EditPopupState) -> Bool {
                switch (lhs, rhs) {
                case (.display, .display), (.dismiss, .dismiss):
                    return true
                default:
                    return false
                }
        }
    }
    public enum UpdateCommentState: Equatable {
        case edit(Int, String)
        case idle
        public static func == (
            lhs: UpdateCommentState,
            rhs: UpdateCommentState) -> Bool {
                switch (lhs, rhs) {
                case (.edit, .edit), (.idle, .idle):
                    return true
                default:
                    return false
                }
        }
    }
}
