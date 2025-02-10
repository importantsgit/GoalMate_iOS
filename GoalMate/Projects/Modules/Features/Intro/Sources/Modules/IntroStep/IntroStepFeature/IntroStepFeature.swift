//
//  IntroStepFeature.swift
//  FeatureIntro
//
//  Created by Importants on 2/10/25.
//

import ComposableArchitecture
import Data
import SwiftUI

@Reducer
public struct IntroStepFeature {
    @ObservableState
    public struct State: Equatable {
        var id: UUID
        public init(
            id: UUID = UUID()
        ) {
            self.id = id
        }
    }
    public enum Action: BindableAction {
        case viewCycling(ViewCyclingAction)
        case view(ViewAction)
        case feature(FeatureAction)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {
        case onAppear
    }
    public enum ViewAction {}
    public enum FeatureAction {}
    @Dependency(\.loginClient) var loginClient
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .viewCycling(action):
                return reduce(into: &state, action: action)
            case let .view(action):
                return reduce(into: &state, action: action)
            case let .feature(action):
                return reduce(into: &state, action: action)
            case .binding(_):
                return .none
            }
        }
    }
}

