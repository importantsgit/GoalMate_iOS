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
                    try await menteeClient.joinGoal(goalId: content.contentId)
                    await send(
                        .feature(
                            .checkPurchaseResponse(
                                .success(content)
                            )
                        )
                    )
                } catch {
                    print(error.localizedDescription)
                    if let error = error as? NetworkError,
                       case let .statusCodeError(code) = error {
                        if code == 403 {
                            print("참여 인원 초과 또는 무료 참여 횟수 초과")
                        } else if code == 404 {
                            print("존재하지 않는 목표")
                        } else if code == 409 {
                            print("이미 참여중인 목표")
                        }
                    }
                    await send(
                        .feature(
                            .checkPurchaseResponse(
                                .failure(error)
                            )
                        )
                    )
                }
            }
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        return .none
    }
}
