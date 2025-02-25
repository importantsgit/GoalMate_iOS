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
            state.isAtLeastFourteenYearsOld = state.isAllTermsAgreed
            return .none
        case .privacyPolicyAgreeButtonTapped:
            state.isPrivacyPolicyAgreed.toggle()
            return .send(.feature(.updateAllAgreeStatus))
        case .termsOfServiceButtonTapped:
            state.isServiceTermsAgreed.toggle()
            return .send(.feature(.updateAllAgreeStatus))
        case .ageVerificationButtonTapped:
            state.isAtLeastFourteenYearsOld.toggle()
            return .send(.feature(.updateAllAgreeStatus))
        case .openTermsOfServiceView:
            guard let url = URL(
                string: Environments.TermsOfServiceURLString
            )
            else { return .none }
            return .run { [url] _ in
                _ = await openURL(url)
            }
        case .openPrivacyPolicyAgreeView:
            guard let url = URL(
                string: Environments.PrivacyPolicyAgreeURLString
            )
            else { return .none }
            return .run { [url] _ in
                _ = await openURL(url)
            }
        case .startButtonTapped:
            return .send(.delegate(.termsAgreementFinished))
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .updateAllAgreeStatus:
            let allSelected = [
                state.isServiceTermsAgreed,
                state.isPrivacyPolicyAgreed,
                state.isAtLeastFourteenYearsOld
            ].allSatisfy { $0 }
            state.isAllTermsAgreed = allSelected
            return .none
        }
    }
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        return .none
    }
}
