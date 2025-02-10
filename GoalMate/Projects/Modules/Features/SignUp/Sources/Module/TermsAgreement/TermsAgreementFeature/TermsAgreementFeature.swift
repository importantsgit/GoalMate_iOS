//
//  TermsAgreementFeature.swift
//  FeatureSignUp
//
//  Created by Importants on 2/7/25.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct TermsAgreementFeature {
    @ObservableState
    public struct State: Equatable {
        var id: UUID
        var isAllTermsAgreed: Bool
        var isServiceTermsAgreed: Bool        // 이용약관
        var isPrivacyPolicyAgreed: Bool       // 개인정보 처리방침
        public init(
            id: UUID = UUID(),
            isAllTermsAgreed: Bool = false,
            isServiceTermsAgreed: Bool = false,
            isPrivacyPolicyAgreed: Bool = false
        ) {
            self.id = id
            self.isAllTermsAgreed = isAllTermsAgreed
            self.isServiceTermsAgreed = isServiceTermsAgreed
            self.isPrivacyPolicyAgreed = isPrivacyPolicyAgreed
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {}
    public enum ViewAction {
        case allAgreeButtonTapped
        case termsOfServiceButtonTapped
        case privacyPolicyAgreeButtonTapped
        case openTermsOfServiceView
        case openPrivacyPolicyAgreeView
        case startButtonTapped
    }
    public enum FeatureAction {}
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
