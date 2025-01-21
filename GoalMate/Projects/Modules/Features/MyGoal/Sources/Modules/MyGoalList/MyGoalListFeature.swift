//
//  MyGoalListFeature.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import ComposableArchitecture

@Reducer
public struct MyGoalListFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        var myGoalList: [MyGoalContent]
        public init(
            myGoalList: [MyGoalContent] = []
        ) {
            self.myGoalList = myGoalList
        }
    }
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case fetchMyGoalContents(Result<[MyGoalContent], Error>)
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
            case .binding:
                return .none
            }
        }
        BindingReducer()
    }
}
