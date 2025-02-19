//
//  MyGoalDetailFeature.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct MyGoalDetailFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public let id: UUID
        let contentId: Int
        var content: MyGoalDetailContent?
        var currentMonth: Date
        var selectedDate: Date
        public init(
            contentId: Int
        ) {
            self.id = UUID()
            self.contentId = contentId
            let today = Date()
            self.currentMonth = today
            self.selectedDate = today
        }
    }
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
    }
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .none
            case .binding:
                return .none
            }
        }
        BindingReducer()
    }
}
