//
//  IntroStepFeature.swift
//  FeatureIntro
//
//  Created by Importants on 2/10/25.
//

import ComposableArchitecture
import Data
import Dependencies
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
        case feature(FeatureAction)
        case delegate(DelegateAction)
        case binding(BindingAction<State>)
    }
    public enum ViewCyclingAction {
        case onAppear
    }
    public enum FeatureAction {
        case checkUpdate
        case checkJailBreak
        case checkPermission
        case checkLogin
    }
    public enum DelegateAction {
        case finishIntro
    }
    @Dependency(\.introClient) var introClient
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .viewCycling(action):
                return reduce(into: &state, action: action)
            case let .feature(action):
                return reduce(into: &state, action: action)
            case let .delegate(action):
                return reduce(into: &state, action: action)
            case .binding:
                return .none
            }
        }
    }
}
