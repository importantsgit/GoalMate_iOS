//
//  MyGoalListView.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import ComposableArchitecture
import SwiftUI

public struct MyGoalListView: View {
    @State var store: StoreOf<MyGoalListFeature>
    public init(store: StoreOf<MyGoalListFeature>) {
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
    MyGoalListView(
        store: .init(
            initialState: .init()
        ) {
            MyGoalListFeature()
        }
    )
}
