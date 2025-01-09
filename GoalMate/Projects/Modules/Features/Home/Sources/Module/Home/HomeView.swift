//
//  HomeView.swift
//  Home
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI

struct HomeView: View {
    @State var store: StoreOf<HomeFeature>
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Text("hello")
            }
            .setMargin()
        }
    }
}

#Preview {
    HomeView(
        store: Store(
            initialState: HomeFeature.State.init(),
            reducer: {
                HomeFeature()
            }
        )
    )
}
