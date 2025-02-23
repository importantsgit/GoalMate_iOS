//
//  MyGoalCompletionFeature.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 2/21/25.
//

import ComposableArchitecture
import Data
import Dependencies
import FeatureCommon
import Foundation
import Utils

@Reducer
public struct MyGoalCompletionFeature {
    @ObservableState
    public struct State: Equatable {
        var id: UUID
        var contentId: Int
        var isLoading: Bool
        var didFailToLoad: Bool
        var toastState: ToastState
        var content: FetchMyGoalDetailResponseDTO.Response.MenteeGoal?
        public init(contentId: Int) {
            self.id = UUID()
            self.contentId = contentId
            self.isLoading = true
            self.didFailToLoad = false
            self.toastState = .hide
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
    }
    public enum ViewAction {
        case backButtonTapped
        case retryButtonTapped
        case moreDetailButtonTapped
        case mentorCommentButtonTapped
        case nextGoalButtonTapped
    }
    public enum FeatureAction {
        case fetchMyGoalCompletionContent
        case checkMyGoalCompletionResponse(FetchMyGoalCompletionResult)
    }
    public enum DelegateAction {
        case showGoalDetail(Int)
        case showGoalList
        case showComment(Int, String?, String?)
        case closeView
    }
    @Dependency(\.menteeClient) var menteeClient
    @Dependency(\.date) var date
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
