//
//  GoalDetailFeature.swift
//  FeatureHome
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
        var currentPage: Int
        var images: [Image]
        public init(
            contentId: String,
            currentPage: Int = 0,
            images: [Image] = []
        ) {
            self.contentId = contentId
            self.currentPage = currentPage
            self.images = images
        }
    }

    public enum Action: BindableAction {
        case onAppear
        case backButtonTapped
        case fetchDetail(Result<GoalContentDetail, Error>)
        case binding(BindingAction<State>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [contentId = state.contentId] send in
                    // 이미지 한번에 호출하기 > TaskGroup
                    await send(.fetchDetail(.success(.init())))
                }
            case let .fetchDetail(result):
                switch result {
                case let .success(detail):
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
