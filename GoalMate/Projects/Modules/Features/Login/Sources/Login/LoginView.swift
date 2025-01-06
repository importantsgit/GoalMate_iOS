//
//  LoginView.swift
//  Login
//
//  Created by 이재훈 on 1/6/25.
//

import ComposableArchitecture
import SwiftUI
import Utils

struct LoginView: View {
    let store: StoreOf<LoginFeature>

    var body: some View {
        Text("Hello, World!")
            .font()
    }
}

@available(iOS 17.0, *)
#Preview {
    LoginView(
        store: Store(
            initialState: LoginFeature.State.init(),
            reducer: {
                LoginFeature()
            }
        )
    )
}
