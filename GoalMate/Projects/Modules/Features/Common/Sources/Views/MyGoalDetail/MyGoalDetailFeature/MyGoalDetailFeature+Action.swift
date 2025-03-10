//
//  MyGoalDetailFeature+Action.swift
//  FeatureCommon
//
//  Created by Importants on 2/20/25.
//

import ComposableArchitecture
import Data
import Foundation
import Utils

extension MyGoalDetailFeature {
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.remainingTime = calculateRemainingTime()
            return .merge(
                .run { send in
                    for await _ in environmentClient.observeCapture() {
                        await send(.feature(.captureDetected))
                    }
                }.cancellable(id: CancelID.observerCancel, cancelInFlight: true),
                .run { send in
                    for await _ in clock.timer(interval: .seconds(1)) {
                        await send(.feature(.timerTicked))
                    }
                }.cancellable(id: CancelID.timerCancel, cancelInFlight: true),
                .send(.feature(.fetchMyGoalDetail(state.selectedDate))),
                .send(.feature(.fetchWeeklyProgress(state.selectedDate)))
            )
        case .onDisappear:
            return .merge(
                .cancel(id: CancelID.timerCancel),
                .cancel(id: CancelID.observerCancel)
            )
        }
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .showGoalDetail:
            guard let content = state.content else { return .none }
            return .send(.delegate(.showGoalDetail(content.goalId)))
        case .backButtonTapped:
            return .send(.delegate(.closeView))
        case .retryButtonTapped:
            state.didFailToLoad = false
            return .send(.feature(.fetchMyGoalDetail(state.selectedDate)))
        case let .todoButtonTapped(todoId, status):
            guard Calendar.current.isDateInToday(state.selectedDate)
            else {
                state.isShowOutdatePopup = true
                return .none
            }
            HapticManager.impact(style: .success)
            state.isTodoLoading = true
            let todoStatus: TodoStatus = (status == .completed ? .todo : .completed)
            return .run { [todoId, menteeGoalId = state.menteeGoalId, todoStatus] send in
                do {
                    let response = try await menteeClient.updateTodo(
                        menteeGoalId: menteeGoalId,
                        todoId: todoId,
                        status: todoStatus
                    )
                    await send(.feature(
                        .checkUpdateTodoResponse(.success(response, todoId))))
                } catch is NetworkError {
                    await send(.feature(
                        .checkUpdateTodoResponse(.networkError)))
                } catch {
                    await send(.feature(
                        .checkUpdateTodoResponse(.failed)))
                }
            }
        case let .todoTipButtonTapped(todoId):
            state.todos[id: todoId]?.isShowTip.toggle()
            return .none
        case .showCommentButtonTapped:
            guard let content = state.content
            else { return .none }
            return .send(.delegate(
                .showComment(content.commentRoomId, content.title, content.endDate)))
        }
    }
    func reduce(into state: inout State, action: CalendarAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .send(.feature(.fetchWeeklyProgress(state.selectedDate)))
        case let .onSwipe(date):
            return .send(.feature(.fetchWeeklyProgress(date)))
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .timerTicked:
            state.remainingTime = calculateRemainingTime()
            return .none
        case .captureDetected:
            state.isShowCapturePopup = true
            return .none
        case let .fetchMyGoalDetail(date):
            state.isContentLoading = true
            return .run { [date, menteeGoalId = state.menteeGoalId] send in
                do {
                    let response = try await menteeClient.fetchMyGoalDetail(
                        menteeGoalId: menteeGoalId,
                        date: date.getString(format: "yyyy-MM-dd")
                    )
                    await send(
                        .feature(.checkFetchMyGoalDetailResponse(.success(response)))
                    )
                } catch let error as NetworkError {
                    print(error.localizedDescription)
                    await send(
                        .feature(.checkFetchMyGoalDetailResponse(.networkError))
                    )
                } catch {
                    print(error.localizedDescription)
                    await send(
                        .feature(.checkFetchMyGoalDetailResponse(.failed))
                    )
                }

            }
        case let .checkFetchMyGoalDetailResponse(result):
            switch result {
            case let .success(content):
                state.content = content.menteeGoal
                state.todos = IdentifiedArray(uniqueElements: content.todos, id: \.id)
                state.isContentLoading = false
            case .networkError:
                state.didFailToLoad = true
                state.isContentLoading = true
            case .failed:
                state.isContentLoading = false
            }
            state.isLoadingWhenDayTapped = false
            return .none
        case let .fetchWeeklyProgress(date):
            return .run { [date, menteeGoalId = state.menteeGoalId] send in
                do {
                    let dateString = date.getString(format: "yyyy-MM-dd")
                    print("fetchWeeklyProgress: \(dateString)")
                    let response = try await menteeClient.fetchWeeklyProgress(
                        menteeGoalId: menteeGoalId,
                        date: dateString
                    )
                    await send(.feature(
                        .checkFetchWeeklyProgressResponse(
                            .success(response.progress)
                        )))
                } catch is NetworkError {
                    await send(.feature(
                        .checkFetchWeeklyProgressResponse(.networkError)
                    ))
                } catch {
                    await send(.feature(
                        .checkFetchWeeklyProgressResponse(.failed)
                    ))
                }
            }
        case let .checkFetchWeeklyProgressResponse(result):
            switch result {
            case let .success(list):
                list.forEach { day in
                    state.weeklyProgress.updateOrAppend(day)
                }
            case .networkError:
                break
            case .failed:
                break
            }
            return .none
        case let .checkUpdateTodoResponse(result):
            switch result {
            case let .success(todo, todoId):
                let today = Date.now.getString(format: "yyyy-MM-dd")
                state.todos[id: todoId]?.todoStatus = todo.todoStatus
                if todo.todoStatus == .completed {
                    state.content?.todayCompletedCount += 1
                    state.content?.totalCompletedCount += 1
                    state.weeklyProgress[id: today]?.completedDailyTodoCount += 1
                } else {
                    state.content?.todayCompletedCount -= 1
                    state.content?.totalCompletedCount -= 1
                    state.weeklyProgress[id: today]?.completedDailyTodoCount -= 1
                }
            case .networkError:
                state.toastState = .display("네트워크에 오류가 발생했습니다.")
            case .failed:
                state.toastState = .display("네트워크에 오류가 발생했습니다.")
            }
            state.isTodoLoading = false
            return .none
        }
    }
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
