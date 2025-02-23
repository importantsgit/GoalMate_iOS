//
//  MyGoalDetailFeature.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import ComposableArchitecture
import Data
import FeatureCommon
import Foundation

@Reducer
public struct MyGoalDetailFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        let menteeGoalId: Int
        var content: FetchMyGoalDetailResponseDTO.Response?
        var todos: IdentifiedArrayOf<Todo>
        var weeklyProgress: IdentifiedArrayOf<DailyProgress>
        var remainingTime: TimeInterval
        var todayCompletedCount: Int
        var isLoadingWhenDayTapped: Bool
        var isContentLoading: Bool
        var isTodoLoading: Bool
        var didFailToLoad: Bool
        var selectedDate: Date
        var isShowPopup: Bool {
            isShowCapturePopup || isShowOutdatePopup
        }
        var isShowOutdatePopup: Bool
        var isShowCapturePopup: Bool
        var toastState: ToastState
        public init(
            menteeGoalId: Int
        ) {
            self.id = UUID()
            self.menteeGoalId = menteeGoalId
            self.isContentLoading = true
            self.isLoadingWhenDayTapped = false
            self.isTodoLoading = false
            self.didFailToLoad = false
            self.todos = []
            self.weeklyProgress = []
            self.selectedDate = Date.now
            self.todayCompletedCount = 0
            self.remainingTime = 0
            self.isShowCapturePopup = false
            self.isShowOutdatePopup = false
            self.toastState = .hide
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case calendar(CalendarAction)
        case feature(FeatureAction)
        case delegate(DelegateAction)
        case dateButtonTapped(Date)
        case dismissCapturePopup(Bool)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {
        case onAppear
        case onDisappear
    }
    public enum CalendarAction {
        case onAppear
        case onSwipe(Date)
    }
    public enum ViewAction {
        case backButtonTapped
        case retryButtonTapped
        case todoButtonTapped(Int, TodoStatus)
        case todoTipButtonTapped(Int)
        case showGoalDetail
        case showCommentButtonTapped
    }
    public enum FeatureAction {
        case captureDetected
        case timerTicked
        case fetchMyGoalDetail(Date)
        case fetchWeeklyProgress(Date)
        case checkFetchMyGoalDetailResponse(FetchMyGoalDetailResult)
        case checkFetchWeeklyProgressResponse(FetchWeeklyProgreessResult)
        case checkUpdateTodoResponse(UpdateTodoStatusResult)
    }
    public enum DelegateAction {
        case showGoalDetail(Int)
        case showComment(Int, String?, String?)
        case closeView
    }
    public enum CancelID: Hashable {
        case timerCancel
        case observerCancel
    }
    @Dependency(\.menteeClient) var menteeClient
    @Dependency(\.date.now) var now
    @Dependency(\.continuousClock) var clock
    @Dependency(\.environmentClient) var environmentClient
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .viewCycling(action):
                return reduce(into: &state, action: action)
            case let .view(action):
                return reduce(into: &state, action: action)
            case let .calendar(action):
                return reduce(into: &state, action: action)
            case let .feature(action):
                return reduce(into: &state, action: action)
            case let .delegate(action):
                return reduce(into: &state, action: action)
            case let .dateButtonTapped(date):
                state.selectedDate = date
                state.isLoadingWhenDayTapped = true
                return .send(.feature(.fetchMyGoalDetail(date)))
            case .dismissCapturePopup:
                state.isShowCapturePopup = false
                state.isShowOutdatePopup = false
                return .none
            case .binding:
                return .none
            }
        }
    }
    func calculateRemainingTime() -> TimeInterval {
        let calendar = Calendar.current
        let now = Date()
        let tomorrow = calendar.startOfDay(
            for: calendar.date(byAdding: .day, value: 1, to: now) ?? now
        )
        return tomorrow.timeIntervalSince(now)
    }
}

extension MyGoalDetailFeature {
    public enum FetchMyGoalDetailResult {
        case success(FetchMyGoalDetailResponseDTO.Response)
        case networkError
        case failed
    }
    public enum UpdateTodoStatusResult {
        case success(Todo, Int)
        case networkError
        case failed
    }
    public enum FetchWeeklyProgreessResult {
        case success([DailyProgress])
        case networkError
        case failed
    }
}
