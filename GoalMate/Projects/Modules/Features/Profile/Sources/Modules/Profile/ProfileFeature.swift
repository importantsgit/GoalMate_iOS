//
//  ProfileFeature.swift
//  FeatureProfile
//
//  Created by 이재훈 on 1/22/25.
//

import ComposableArchitecture

@Reducer
public struct ProfileFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        var profile: ProfileContent? = nil
        public init() {}
    }
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case qnaButtonTapped
        case privacyPolicyButtonTapped
        case termsOfServiceButtonTapped
        case withdrawalButtonTapped
        case fetchMyGoalCount(Result<ProfileContent, Error>)
    }
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    await send(.fetchMyGoalCount(.success(ProfileContent.dummy)))
                }
            case let .fetchMyGoalCount(result):
                switch result {
                case let .success(list):
                    state.profile = list
                case let .failure(error):
                    break
                }
                return .none
            case .withdrawalButtonTapped,
                    .qnaButtonTapped,
                    .termsOfServiceButtonTapped,
                    .privacyPolicyButtonTapped:
                return .none
            case .binding:
                return .none
            }
        }
        BindingReducer()
    }
}
