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
        var isLogin: Bool
        var isShowPopup: Bool
        var didFailToLoad: Bool
        public init() {
            self.id = UUID()
            self.isLoading = true
            self.isLogin = false
            self.isShowPopup = false
            self.didFailToLoad = false
            self.profile = nil
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
        case dismissPopup(Bool)
    }
    public enum ViewCyclingAction {
        case onAppear
    }
    public enum ViewAction {
        case loginButtonTapped
        case nicknameEditButtonTapped
        case qnaButtonTapped
        case privacyPolicyButtonTapped
        case termsOfServiceButtonTapped
        case withdrawalButtonTapped
        case retryButtonTapped
        case goalStatusButtonTapped
        case logoutConfirmButtonTapped
        case logoutButtonTapped
    }
    public enum FeatureAction {
        case checkLogin(Bool)
        case logout
        case checkLogout(Bool)
        case fetchProfile
        case checkProfileResponse(FetchProfileResult)
    }
    public enum DelegateAction {
        case showLogin
        case showGoalList
        case showMyGoalList
        case showWithdrawal
        case showNicknameEdit(String)
        case setNickname(String)
    }
    @Dependency(\.authClient) var authClient
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
            case let .delegate(action):
                return reduce(into: &state, action: action)
            case let .dismissPopup(isDismiss):
                state.isShowPopup = isDismiss
                return .none
            case .binding(_):
                return .none
            }
        }
    }
}

extension ProfileFeature {
    public enum FetchProfileResult {
        case success(ProfileContent)
        case networkError
        case failed
    }
}
