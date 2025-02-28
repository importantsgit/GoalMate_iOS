//
//  GoalDetailSheetFeature+Action.swift
//  FeatureGoal
//
//  Created by Importants on 2/16/25.
//

import ComposableArchitecture
import Data
import Foundation
import Utils

extension GoalDetailSheetFeature {
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        return .none
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .purchaseButtonTapped:
            return .run { [content = state.content] send in
                do {
                    let joinGoalInfo = try await menteeClient.joinGoal(goalId: content.contentId)
                    var newContent = content
                    newContent.setJoinGoalInfo(
                        menteeGoalId: joinGoalInfo.menteeGoalId,
                        commentRoomId: joinGoalInfo.commentRoomId
                    )
                    await send(
                        .feature(
                            .checkPurchaseResponse(
                                .success(newContent)
                            )
                        )
                    )
                } catch {
                    print(error.localizedDescription)
                    if let error = error as? NetworkError,
                       case let .statusCodeError(code) = error {
                        let message: String
                        if code == 403 {
                            message = "참여 인원 초과 또는 무료 참여 횟수 초과입니다."
                        } else if code == 404 {
                            message = "존재하지 않는 목표입니다."
                        } else if code == 409 {
                            message = "이미 참여중인 목표입니다."
                        } else {
                            message = "알 수 없는 오류가 발생했습니다."
                        }
                        await send(
                            .feature(.checkPurchaseResponse(.failed(message))))
                        return
                    }
                    await send(.feature(.checkPurchaseResponse(.networkError)))
                }
            }
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case let .checkPurchaseResponse(result):
            switch result {
            case let .success(result):
                return .send(.delegate(.finishPurchase(result)))
            case let .failed(message):
                state.toastState = .display(message)
                return .send(.delegate(.failed(message)))
            case .networkError:
                state.toastState = .display("네트워크 오류가 발생했습니다.")
                return .send(.delegate(.failed("네트워크 오류가 발생했습니다.")))
            }
        }
    }
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
