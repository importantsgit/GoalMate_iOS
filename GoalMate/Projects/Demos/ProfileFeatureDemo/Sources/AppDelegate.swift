//
//  AppDelegate.swift
//  DemoProfileFeature
//
//  Created by Importants on 2/4/25.
//

import ComposableArchitecture
import Foundation
import TCACoordinators
import UIKit

@Reducer
public struct AppDelegateReducer {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case didFinishLaunching
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didFinishLaunching:
                return .run { send in
                    await withThrowingTaskGroup(of: Void.self) { group in
                        group.addTask {}
                    }
                }
            }
        }
    }
}
