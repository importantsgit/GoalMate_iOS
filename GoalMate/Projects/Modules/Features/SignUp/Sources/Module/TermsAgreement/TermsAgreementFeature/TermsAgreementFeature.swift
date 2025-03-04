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
    public init() {}
    @ObservableState
    public struct State: Equatable {
        public var id: UUID
        var isAllTermsAgreed: Bool
        var isServiceTermsAgreed: Bool        // 이용약관
        var isPrivacyPolicyAgreed: Bool       // 개인정보 처리방침
        var isAtLeastFourteenYearsOld: Bool   // 만 14세 이상
        public init(
            id: UUID = UUID(),
            isAllTermsAgreed: Bool = false,
            isServiceTermsAgreed: Bool = false,
            isPrivacyPolicyAgreed: Bool = false,
            isAtLeastFourteenYearsOld: Bool = false
        ) {
            self.id = id
            self.isAllTermsAgreed = isAllTermsAgreed
            self.isServiceTermsAgreed = isServiceTermsAgreed
            self.isPrivacyPolicyAgreed = isPrivacyPolicyAgreed
            self.isAtLeastFourteenYearsOld = isAtLeastFourteenYearsOld
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {}
    public enum ViewAction {
        case allAgreeButtonTapped
        case termsOfServiceButtonTapped
        case privacyPolicyAgreeButtonTapped
        case ageVerificationButtonTapped
        case openTermsOfServiceView
        case openPrivacyPolicyAgreeView
        case startButtonTapped
    }
    public enum FeatureAction {
        case updateAllAgreeStatus
    }
    public enum DelegateAction {
        case termsAgreementFinished
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
            case let .delegate(action):
                return reduce(into: &state, action: action)
            case .binding(_):
                return .none
            }
        }
    }
}
