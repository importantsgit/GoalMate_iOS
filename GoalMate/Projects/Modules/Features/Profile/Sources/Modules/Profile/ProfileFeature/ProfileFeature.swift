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
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {
        case onAppear
    }
    public enum ViewAction {
        case qnaButtonTapped
        case privacyPolicyButtonTapped
        case termsOfServiceButtonTapped
        case withdrawalButtonTapped
    }
    public enum FeatureAction {
        case fetchMyGoalCount(Result<ProfileContent, Error>)
    }
    @Dependency(\.openURL) var openURL
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .viewCycling(action):
                return reduce(into: &state, action: action)
            case let .view(action):
                return reduce(into: &state, action: action)
            case let .feature(action):
                return reduce(into: &state, action: action)
            case .binding(_):
                return .none
            }
        }
    }
}
