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
            return .send(.feature(.checkUpdate))
        }
    }
    func reduce(into state: inout State, action: FeatureAction) -> Effect<Action> {
        switch action {
        case .checkUpdate:
            return .send(.feature(.checkLogin))
        case .checkLogin:
            return .run { send in
                do {
                    let result = try await authClient.validateSession()
                    print("login Success: \(result)")
                } catch {
                    print(error)
                }
                await send(.feature(.check))
            }
        case .check:
            return .send(.feature(.finishIntro))
        case .finishIntro:
            return .none
        }
    }
}
