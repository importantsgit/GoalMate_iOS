//
//  AppView.swift
//  Login
//
//  Created by Importants on 1/7/25.
//

import CasePaths
import ComposableArchitecture
import IdentifiedCollections
import Login
import Sharing
import SwiftUI

struct AppView: View {
    @Shared(.path) var path

    public var body: some View {
        NavigationStack(path: Binding($path)) {

        }
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
    AppView()
}
