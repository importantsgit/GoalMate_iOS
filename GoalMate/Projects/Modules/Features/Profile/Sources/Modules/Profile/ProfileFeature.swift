//
//  ProfileFeature.swift
//  FeatureProfile
//
//  Created by 이재훈 on 1/22/25.
//

import ComposableArchitecture
import Dependencies
import Foundation

@Reducer
public struct ProfileFeature {
    public init() {}
    @ObservableState
    public struct State: Equatable {
        var profile: ProfileContent?
        public init() {
            profile = nil
        }
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
    @Dependency(\.openURL) var openURL
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
            case .termsOfServiceButtonTapped:
                guard let url = URL(
                    string: "https://ash-oregano-9dc.notion.site/f97185c23c5444b4ae3796928ae7f646?pvs=74"
                )
                else { return .none }
                return .run { [url] _ in
                    _ = await openURL(url)
                }
            case .privacyPolicyButtonTapped:
                guard let url = URL(
                    string: "https://ash-oregano-9dc.notion.site/997827990f694f63a60b06c06beb1468"
                )
                else { return .none }
                return .run { [url] _ in
                    _ = await openURL(url)
                }
            case .withdrawalButtonTapped,
                    .qnaButtonTapped:
                return .none
            case .binding:
                return .none
            }
        }
        BindingReducer()
    }
}
