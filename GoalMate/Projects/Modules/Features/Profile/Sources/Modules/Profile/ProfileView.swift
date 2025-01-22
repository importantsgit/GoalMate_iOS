//
//  ProfileView.swift
//  FeatureProfile
//
//  Created by 이재훈 on 1/22/25.
//


import ComposableArchitecture
import FeatureCommon
import SwiftUI
import Utils

public struct ProfileView: View {
    @State var store: StoreOf<ProfileFeature>
    public init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }
    public var body: some View {
        Text("Profile")
    }
}

@available(iOS 17.0, *)
#Preview {
    ProfileView(
        store: .init(
            initialState: .init()
        ) {
            ProfileFeature()
        }
    )
}
