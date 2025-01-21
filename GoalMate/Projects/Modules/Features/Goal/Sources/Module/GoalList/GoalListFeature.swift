//
//  GoalListFeature.swift
//  FeatureGoal
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture

@Reducer
public struct GoalListFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        var isLoading: Bool
        var goalContents: [GoalContent]
        public init(
            isLoading: Bool = false,
            goalContents: [GoalContent] = []
        ) {
            self.isLoading = false
            self.goalContents = goalContents
        }
    }
    public enum Action: BindableAction {
        case onAppear
        case fetchGoalContents(Result<[GoalContent], Error>)
        case binding(BindingAction<State>)
        case contentTapped(String)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try await Task.sleep(for: .seconds(2))
                    await send(.fetchGoalContents(.success(GoalContent.dummies)))
                }
            case let .fetchGoalContents(result):
                switch result {
                case let .success(contents):
                    print("success!")
                    state.goalContents.append(contentsOf: contents)
                    return .none
                case let .failure(error):
                    return .none
                }
            case let .contentTapped(id):
                print("contentTapped: \(id)")
                return .none
            case .binding:
                return .none

            }
        }
        BindingReducer()
    }
}
