//
//  GoalDetailFeature.swift
//  FeatureGoal
//
//  Created by 이재훈 on 1/9/25.
//

import ComposableArchitecture
import Data
import FeatureCommon
import SwiftUI

@Reducer
public struct GoalDetailFeature {
    public enum FetchError: Error {
        case networkError
        case emptyData
    }
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        let contentId: Int
        var content: GoalContentDetail?
        var isShowUnavailablePopup: Bool
        var currentPage: Int
        var isLoading: Bool
        var didFailToLoad: Bool
        var isLogin: Bool
        var toastState: ToastState
        public init(
            contentId: Int,
            isShowUnavailablePopup: Bool = false,
            currentPage: Int = 0,
            isLoading: Bool = true,
            isLogin: Bool = false
        ) {
            self.id = UUID()
            self.contentId = contentId
            self.isShowUnavailablePopup = isShowUnavailablePopup
            self.currentPage = currentPage
            self.isLoading = true
            self.isLogin = false
            self.didFailToLoad = false
            self.toastState = .hide
        }
    }

    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {
        case onAppear
    }
    public enum ViewAction {
        case backButtonTapped
        case startButtonTapped
        case loginButtonTapped
        case popupButtonTapped
        case retryButtonTapped
    }
    public enum FeatureAction {
        case fetchDetail
        case checkLogin
        case checkLoginResponss(Bool)
        case checkFetchDetailResponse(Result<GoalContentDetail, Error>)
        case showPurchaseSheet(GoalContentDetail)
        case showToast(String)
    }
    @Dependency(\.goalClient) var goalClient
    @Dependency(\.authClient) var authClient
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
            case .binding:
                return .none
            }
        }
    }
}
