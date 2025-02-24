//
//  IntroStepView.swift
//  FeatureIntro
//
//  Created by Importants on 2/10/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI

public struct IntroStepView: View {
    @Perception.Bindable var store: StoreOf<IntroStepFeature>
    public init(store: StoreOf<IntroStepFeature>) {
        self.store = store
    }
    public var body: some View {
        ZStack {
            Colors.primary
                .ignoresSafeArea()
            Images.launchScreenLogo
                .resized(size: .init(width: 178, height: 78))
        }
        .task {
            store.send(.viewCycling(.onAppear))
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    IntroStepView(
        store: Store(
            initialState: IntroStepFeature.State.init(),
            reducer: {
                IntroStepFeature()
            }
        )
    )
}
