//
//  GoalDetailFeature.swift
//  FeatureGoal
//
//  Created by 이재훈 on 1/9/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI

@Reducer
public struct GoalDetailFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        let contentId: String
        var content: GoalContentDetail?
        var isShowPurchaseView: Bool
        var isShowUnavailablePopup: Bool
        var currentPage: Int
        var images: [Image]
        public init(
            contentId: String,
            isShowPurchaseView: Bool = false,
            isShowUnavailablePopup: Bool = false,
            currentPage: Int = 0,
            images: [Image] = []
        ) {
            self.contentId = contentId
            self.images = images
            self.isShowPurchaseView = isShowPurchaseView
            self.isShowUnavailablePopup = isShowUnavailablePopup
            self.currentPage = currentPage
        }
    }

    public enum Action: BindableAction {
        case onAppear
        case backButtonTapped
        case startButtonTapped
        case popupButtonTapped
        case purchaseButtonTapped
        case showPaymentCompleted(GoalContentDetail)
        case fetchDetail(Result<GoalContentDetail, Error>)
        case binding(BindingAction<State>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [contentId = state.contentId] send in
                    // 이미지 한번에 호출하기 > TaskGroup
                    await send(.fetchDetail(.success(.dummy)))
                }
            case .startButtonTapped:
                state.isShowPurchaseView = true
                return .none
            case .popupButtonTapped:
                state.isShowUnavailablePopup = false
                return .none
            case .purchaseButtonTapped:
                guard let content = state.content
                else { return .none }
                return .run { [content = content] send in
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    await send(.showPaymentCompleted(content))
                }
            case .showPaymentCompleted:
                state.isShowPurchaseView = false
                return .none
            case let .fetchDetail(result):
                switch result {
                case let .success(detail):
                    state.content = detail
                    state.images.append(contentsOf: [
                        Images.alarm, Images.check, Images.kakaoLogo
                    ])
                    return .none
                case let .failure(error):
                    return .none
                }
            case .backButtonTapped:
                return .none
            case .binding:
                return .none
            }
        }
        BindingReducer()
    }
}
