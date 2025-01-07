//
//  AppDelegate.swift
//  DemoLoginFeature
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture
import Foundation
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    let store = Store(
        initialState: AppReducer.State()
    ) {
        AppReducer().transformDependency(\.sef) { dependency in
            // 의존성 변환
        }
    }
}


@Reducer
struct AppReducer {
    @Reducer(state: .encodable)
    public enum Destination {
        case Login
    }
    
    @ObservableState
    public struct State: Equatable {
        public var appDelegate: AppDelegateReducer.State
        @Presents public var destination: Destination.State?
        public var home: Login.State
    }
}

@Reducer
public struct AppDelegateReducer {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case didFinishingLaunching
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .didFinishingLaunching:
                return .run { send in
                    await withThrowingTaskGroup(of: Void.self) { group in
                        group.addTask {
                            
                        }
                    }
                }
            }
        }
    }
}
