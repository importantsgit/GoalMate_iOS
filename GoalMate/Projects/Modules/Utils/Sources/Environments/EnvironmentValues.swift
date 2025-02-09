//
//  EnvironmentValues.swift
//  FeatureCommon
//
//  Created by Importants on 2/10/25.
//

import SwiftUI
import UIKit

// MARK: - Environment Key 정의
private struct CurrentSceneKey: EnvironmentKey {
    static var defaultValue: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
    }
}

private struct OrientationKey: EnvironmentKey {
    static var defaultValue: UIInterfaceOrientation {
        guard let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive })
        else {
            return UIDevice.current.orientation.isLandscape ? .landscapeLeft : .portrait
        }
        return scene.interfaceOrientation
    }
}

private struct CurrentWindowKey: EnvironmentKey {
    static var defaultValue: UIWindow? {
        CurrentSceneKey.defaultValue?.windows.first(where: { $0.isKeyWindow })
    }
}

private struct CurrentWindowSizeKey: EnvironmentKey {
    static var defaultValue: CGRect? {
        CurrentWindowKey.defaultValue?.frame
    }
}

private struct SafeAreaInsetKey: EnvironmentKey {
    static var defaultValue: UIEdgeInsets {
        let defaultInsets = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
        return CurrentWindowKey.defaultValue?.safeAreaInsets ?? defaultInsets
    }
}

// MARK: - EnvironmentValues 확장
public extension EnvironmentValues {
    var currentScene: UIWindowScene? {
        get { self[CurrentSceneKey.self] }
        set { self[CurrentSceneKey.self] = newValue }
    }

    var orientation: UIInterfaceOrientation {
        get { self[OrientationKey.self] }
        set { self[OrientationKey.self] = newValue }
    }

    var currentWindow: UIWindow? {
        get { self[CurrentWindowKey.self] }
        set { self[CurrentWindowKey.self] = newValue }
    }

    var currentWindowSize: CGRect? {
        get { self[CurrentWindowSizeKey.self] }
        set { self[CurrentWindowSizeKey.self] = newValue }
    }

    var safeAreaInsets: UIEdgeInsets {
        get { self[SafeAreaInsetKey.self] }
        set { self[SafeAreaInsetKey.self] = newValue }
    }
}
