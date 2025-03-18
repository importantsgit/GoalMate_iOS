//
//  MyGoalCompletionFeature+Action.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 2/21/25.
//

import ComposableArchitecture
import Data
import Foundation

extension MyGoalCompletionFeature {
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            return .merge(
                .send(.feature(.fetchMyGoalCompletionContent)),
                .send(.feature(.fetchMenteeName))
            )
        }
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .backButtonTapped:
            return .send(.delegate(.closeView))
        case .mentorCommentButtonTapped:
            guard let content = state.content else { return .none }
            return .send(.delegate(
                .showComment(content.commentRoomId, content.title, content.endDate)))
        case .moreDetailButtonTapped:
            guard let content = state.content else { return .none }
            return .send(.delegate(.showGoalDetail(content.goalId)))
        case .nextGoalButtonTapped:
            return .send(.delegate(.showGoalList))
        case .retryButtonTapped:
            return .send(.feature(.fetchMyGoalCompletionContent))
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .fetchMenteeName:
            return .run { send in
                do {
                    let menteeInfo = try await menteeClient.fetchMenteeInfo()
                    await send(.feature(
                        .checkMenteeNameResponse(menteeInfo.name)))
                } catch {
                    await send(.feature(
                        .checkMenteeNameResponse(nil)))
                }
            }
        case let .checkMenteeNameResponse(name):
            state.menteeName = name
            return .none
        case .fetchMyGoalCompletionContent:
            state.isLoading = true
            return .run { [menteeGoalId = state.contentId] send in
                do {
                    let dateFormater = DateFormatter()
                    dateFormater.dateFormat = "yyyy-MM-dd"
                    let date = dateFormater.string(from: date.now)
                    let response = try await menteeClient.fetchMyGoalDetail(
                        menteeGoalId: menteeGoalId,
                        date: date
                    )
                    guard let content = response.menteeGoal
                    else { return }
                    await send(.feature(
                        .checkMyGoalCompletionResponse(.success(content))))
                } catch is NetworkError {
                    await send(.feature(
                        .checkMyGoalCompletionResponse(.networkError)))
                } catch {
                    await send(.feature(
                        .checkMyGoalCompletionResponse(.failed)))
                }
            }
        case let .checkMyGoalCompletionResponse(response):
            switch response {
            case let .success(content):
                state.content = content
                state.isLoading = false
                return .none
            case .networkError:
                state.toastState = .display("네트워크 오류가 발생했습니다")
                state.didFailToLoad = true
                state.isLoading = false
                return .none
            case .failed:
                state.toastState = .display("오류가 발생했습니다.")
                state.didFailToLoad = true
                state.isLoading = false
                return .none
            }
        }
    }
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
