//
//  MyGoalDetailView.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import ComposableArchitecture
import SwiftUI

public struct MyGoalDetailView: View {
    @State var store: StoreOf<MyGoalDetailFeature>
    public init(store: StoreOf<MyGoalDetailFeature>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            Text("")
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    MyGoalDetailView(
        store: .init(
            initialState: .init()
        ) {
            MyGoalDetailFeature()
        }
    )
}
