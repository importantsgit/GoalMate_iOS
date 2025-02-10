//
//  IntroStepFeature+Action.swift
//  FeatureIntro
//
//  Created by Importants on 2/11/25.
//

import ComposableArchitecture

extension IntroStepFeature {
    func reduce(into state: inout State, action: ViewCyclingAction) -> Effect<Action> {
        switch action {
        case .onAppear:
            break
        }
        return .none
    }
    func reduce(into state: inout State, action: ViewAction) -> Effect<Action> {
        return .none
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        return .none
    }
}
