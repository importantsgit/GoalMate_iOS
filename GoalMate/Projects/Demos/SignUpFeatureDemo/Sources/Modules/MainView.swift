//
//  MainView.swift
//  DemoSignUpFeature
//
//  Created by Importants on 2/28/25.
//

import ComposableArchitecture
import SwiftUI

public struct MainView: View {
    @Perception.Bindable var store: StoreOf<MainFeature>
    public var body: some View {
        WithPerceptionTracking {
            List {
                Button("로그인") {
                    store.send(.view(.loginFlow))
                }
                Button("회원가입") {
                    store.send(.view(.signUpFlow))
                }
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    MainView(
        store: Store(
            initialState: MainFeature.State.init(),
            reducer: {
                withDependencies {
                    $0.calendar = .current
                } operation: {
                    MainFeature()
                }
            }
        )
    )
}

