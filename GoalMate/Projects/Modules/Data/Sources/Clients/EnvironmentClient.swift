//
//  EnvironmentClient.swift
//  Data
//
//  Created by Importants on 2/7/25.
//

import Dependencies
import Foundation
import UIKit

// MARK: - KeyboardClient
public struct EnvironmentClient {
    public let observeKeyboardHeight: () -> AsyncStream<CGFloat>
    public let observeCapture: () -> AsyncStream<MediaType>
    public let dismissKeyboard: () async -> Void
}

// MARK: - DependencyKey
extension EnvironmentClient: DependencyKey {
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
                        continuation.yield(keyboardRect.height)
                        continuation.finish()  // 첫 번째 높이를 받은 후 즉시 종료
                    }
                    continuation.onTermination = { _ in
                        notificationCenter.removeObserver(observer)
                    }
                }
            },
            observeCapture: {
                AsyncStream { continuation in
                    let notificationCenter = NotificationCenter.default
                    let capturePhoto = notificationCenter.addObserver(
                        forName: UIApplication.userDidTakeScreenshotNotification,
                        object: nil,
                        queue: .current
                    ) { _ in
                        continuation.yield(.photo)
                    }
                    let captureVideo = notificationCenter.addObserver(
                        forName: UIScreen.capturedDidChangeNotification,
                        object: nil,
                        queue: .current
                    ) { _ in
                        continuation.yield(.video(true))
                    }
                    continuation.onTermination = { _ in
                        notificationCenter.removeObserver(capturePhoto)
                        notificationCenter.removeObserver(captureVideo)
                    }
                }
            },
            dismissKeyboard: {
                _ = await MainActor.run {
                    UIApplication.shared.sendAction(
                        #selector(
                            UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil
                    )
                }
            }
        )
    }()

    public static let previewValue: Self = {
        return .init(
            observeKeyboardHeight: {
                AsyncStream { continuation in
                    continuation.yield(300)
                    continuation.finish()
                }
            },
            observeCapture: {
                AsyncStream { continuation in
                    continuation.yield(.photo)
                    continuation.finish()
                }
            }, dismissKeyboard: {}
        )
    }()
}

public extension DependencyValues {
    var environmentClient: EnvironmentClient {
        get { self[EnvironmentClient.self] }
        set { self[EnvironmentClient.self] = newValue }
    }
}

public enum MediaType {
    case photo
    case video(Bool)
    var value: String {
        switch self {
        case .photo: return "PHOTO"
        case .video: return "VIDEO"
        }
    }
}
