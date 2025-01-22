//
//  MyGoalListFeature.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import ComposableArchitecture
import Foundation

public enum ButtonType {
    case view(Int)
    case restart(Int)
}

public struct MyGoalDetailData {
    let id: Int
    let startDate: Date
    let endDate: Date
}

@Reducer
public struct MyGoalListFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        var myGoalList: IdentifiedArrayOf<MyGoalContent>
        public init(
            myGoalList: IdentifiedArrayOf<MyGoalContent> = []
        ) {
            self.myGoalList = myGoalList
        }
    }
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case fetchMyGoalContents(Result<IdentifiedArrayOf<MyGoalContent>, Error>)
        case buttonTapped(ButtonType)
        case showMyGoalDetail(MyGoalDetailData)
        case showGoalDetail(Int)
    }
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    await send(.fetchMyGoalContents(.success(MyGoalContent.dummies)))
                }
            case let .fetchMyGoalContents(result):
                switch result {
                case let .success(list):
                    state.myGoalList = list
                case let .failure(error):
                    break
                }
                return .none
            case let .buttonTapped(type):
                switch type {
                case let .restart(id):
                    return .send(.showGoalDetail(id))
                case let .view(id):
                    guard let myGoal = state.myGoalList[id: id] else { break }
                    return .send(.showMyGoalDetail(.init(
                        id: id,
                        startDate: myGoal.startDate,
                        endDate: myGoal.endDate
                    )))
                }
                return .none
            case .binding:
                return .none
            default: return .none
            }
        }
        BindingReducer()
    }
}
