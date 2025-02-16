//
//  AppDelegate.swift
//  DemoSignUpFeature
//
//  Created by Importants on 1/8/25.
//

import ComposableArchitecture
import Foundation
import KakaoSDKCommon
import TCACoordinators
import UIKit
import Utils

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
                KakaoSDK.initSDK(appKey: Environments.kakaoKey)
                return .run { send in
                    await withThrowingTaskGroup(of: Void.self) { group in
                        group.addTask {}
                        
                        
                    }
                }
            }
        }
    }
}
