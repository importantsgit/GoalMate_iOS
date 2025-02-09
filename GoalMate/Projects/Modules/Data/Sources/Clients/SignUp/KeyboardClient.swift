//
//  KeyboardClient.swift
//  Data
//
//  Created by Importants on 2/7/25.
//

import Dependencies
import Foundation
import UIKit

// MARK: - KeyboardClient
public struct KeyboardClient {
    public let observeKeyboardHeight: () -> AsyncStream<CGFloat>
}

// MARK: - DependencyKey
extension KeyboardClient: DependencyKey {
    public static let liveValue: Self = {
        return .init(
            observeKeyboardHeight: {
                AsyncStream { continuation in
                    let notificationCenter = NotificationCenter.default
                    let observer = notificationCenter.addObserver(
                        forName: UIResponder.keyboardWillShowNotification,
                        object: nil,
                        queue: .main
                    ) { notification in
                        guard let userInfo = notification.userInfo,
                              let keyboardRect = userInfo[
                                UIResponder.keyboardFrameEndUserInfoKey
                              ] as? CGRect
                        else { return }
                        print("data: \(keyboardRect.height)")
                        continuation.yield(keyboardRect.height)
                        continuation.finish()  // 첫 번째 높이를 받은 후 즉시 종료
                    }
                    continuation.onTermination = { _ in
                        notificationCenter.removeObserver(observer)
                    }
                }
            }
        )
    }()

    public static let previewValue: Self = {
        return .init {
            AsyncStream { continuation in
                continuation.yield(300)
                continuation.finish()
            }
        }
    }()
}

public extension DependencyValues {
    var keyboardClient: KeyboardClient {
        get { self[KeyboardClient.self] }
        set { self[KeyboardClient.self] = newValue }
    }
}
