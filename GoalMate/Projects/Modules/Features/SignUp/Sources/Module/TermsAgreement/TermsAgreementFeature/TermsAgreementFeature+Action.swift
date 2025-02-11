//
//  TermsAgreementFeature+Action.swift
//  FeatureSignUp
//
//  Created by Importants on 2/9/25.
//

import ComposableArchitecture
import Foundation
import Utils

extension TermsAgreementFeature {
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        return .none
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        switch action {
        case .allAgreeButtonTapped:
            state.isAllTermsAgreed.toggle()
            state.isServiceTermsAgreed = state.isAllTermsAgreed
            state.isPrivacyPolicyAgreed = state.isAllTermsAgreed
            return .none
        case .privacyPolicyAgreeButtonTapped:
            state.isPrivacyPolicyAgreed.toggle()
            if state.isServiceTermsAgreed &&
                state.isPrivacyPolicyAgreed {
                state.isAllTermsAgreed = true
            } else if state.isPrivacyPolicyAgreed == false {
                state.isAllTermsAgreed = false
            }
            return .none
        case .termsOfServiceButtonTapped:
            state.isServiceTermsAgreed.toggle()
            if state.isServiceTermsAgreed &&
                state.isPrivacyPolicyAgreed {
                state.isAllTermsAgreed = true
            } else if state.isServiceTermsAgreed == false {
                state.isAllTermsAgreed = false
            }
            return .none
        case .openTermsOfServiceView:
            guard let url = URL(
                string: Environments.TermsOfServiceURL
            )
            else { return .none }
            return .run { [url] _ in
                _ = await openURL(url)
            }
        case .openPrivacyPolicyAgreeView:
            guard let url = URL(
                string: Environments.PrivacyPolicyAgreeURL
            )
            else { return .none }
            return .run { [url] _ in
                _ = await openURL(url)
            }
        case .startButtonTapped:
            return .none
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        return .none
    }
}
