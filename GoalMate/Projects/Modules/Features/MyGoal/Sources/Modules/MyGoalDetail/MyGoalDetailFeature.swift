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
        let id: Int
        var content: MyGoalDetailContent?
        let startDate: Date
        let endDate: Date
        var currentMonth: Date
        var selectedDate: Date
        public init(
            id: Int,
            startDate: Date,
            endDate: Date
        ) {
            self.id = id
            self.startDate = startDate
            self.endDate = endDate
            let today = Date()
            self.currentMonth = today
            self.selectedDate = today
        }
    }
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
    }
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
        BindingReducer()
    }
}
