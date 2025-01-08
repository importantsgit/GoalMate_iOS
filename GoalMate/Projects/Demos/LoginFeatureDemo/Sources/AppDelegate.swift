//
//  AppDelegate.swift
//  DemoLoginFeature
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture
import Foundation
import UIKit

@Reducer
struct AppReducer {
    @Reducer(state: .encodable)
    public enum Destination {
        case login
    }
    
    @ObservableState
    public struct State: Equatable {
        public var appDelegate: AppDelegateReducer.State
        @Presents public var destination: Destination.State?
        
        init(
            appDelegate: AppDelegateReducer.State,
            destination: Destination.State? = nil
        ) {
            self.appDelegate = appDelegate
            self.destination = destination
        }
    }
    
    public enum Action {
        case appDelegate(AppDelegateReducer.Action)
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
