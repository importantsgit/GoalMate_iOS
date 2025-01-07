//
//  ContentView.swift
//  Login
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture
import Login
import SwiftUI

struct ContentView: View {
    public var body: some View {
        NicknameView(
            store: Store(
                initialState: NicknameFeature.State.init(),
                reducer: {
                    NicknameFeature()
                }
            )
        )
    }
}

@available(iOS 17.0, *)
#Preview {
    ContentView()
}
