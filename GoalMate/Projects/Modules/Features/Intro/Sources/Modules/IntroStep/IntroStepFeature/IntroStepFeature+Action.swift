//
//  IntroStepFeature+Action.swift
//  FeatureIntro
//
//  Created by Importants on 2/11/25.
//

import ComposableArchitecture
import Data

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
            return .run { send in
                do {
                    let hasUpdate = try await introClient.checkUpdate()
                    switch hasUpdate {
                    case .none:
                        break
                    case .update:
                        break
                    }
                } catch {
                    // TODO: 추후 업데이트 로직 추가
                }
                await send(.feature(.checkJailBreak))
            }
        case .checkJailBreak:
            return .run { send in
                if introClient.checkJailBreak() {
                    // TODO: 추후 탈옥 감지 로직 추가
                }
                await send(.feature(.checkPermission))
            }
        case .checkPermission:
            return .run { send in
                // TODO: 추후 권한 체크 로직 추가
                await send(.feature(.checkLogin))
            }
        case .checkLogin:
            return .run { send in
                do {
                    let result = try await introClient.checkLogin()
                } catch {
                    print(error.localizedDescription)
                }
                await send(.delegate(.finishIntro))
            }
        }
    }
    func reduce(into state: inout State, action: DelegateAction) -> Effect<Action> {
        switch action {
        case .finishIntro:
            return .none
        }
    }
}
