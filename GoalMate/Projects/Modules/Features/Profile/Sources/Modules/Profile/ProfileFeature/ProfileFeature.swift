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
        public let id: UUID
        var name: String?
        var profile: ProfileContent?
        var isLoading: Bool
        var didFailToLoad: Bool
        public init() {
            self.id = UUID()
            self.isLoading = true
            self.didFailToLoad = false
            self.profile = nil
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
        case nicknameEditButtonTapped
        case qnaButtonTapped
        case privacyPolicyButtonTapped
        case termsOfServiceButtonTapped
        case withdrawalButtonTapped
        case setNickname(String)
        case retryButtonTapped
    }
    public enum FeatureAction {
        case fetchMyGoalCount(Result<ProfileContent, Error>)
        case showNicknameEdit(String)
    }
    @Dependency(\.menteeClient) var menteeClient
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
