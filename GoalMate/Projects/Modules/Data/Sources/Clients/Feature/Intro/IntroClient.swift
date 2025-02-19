//
//  IntroClient.swift
//  Data
//
//  Created by 이재훈 on 2/19/25.
//

import Dependencies
import DependenciesMacros
import Foundation
import Utils

@DependencyClient
public struct IntroClient {
    public var checkJailBreak: () -> Bool = { false }
    public var checkUpdate: () async throws -> UpdateStatus
    public var checkLogin: () async -> Bool = { false }
}

extension IntroClient: DependencyKey {
    public static var liveValue: IntroClient {
        @Dependency(\.authClient) var authClient
        return .init(
            checkJailBreak: JailbreakDetector.checkJailBreak,
            checkUpdate: {
                let currentVersion = Version(
                    from: Bundle.main.infoDictionary?[
                        "CFBundleShortVersionString"
                    ] as? String ?? "1.0.0"
                )
                let bundleId = Bundle.main.bundleIdentifier 
                ?? "com.lguplus.remocon"
                guard let url = URL(
                    string: "http://itunes.apple.com/lookup?bundleId=\(bundleId)&country=KR"
                ) else { return .none }
                let (data, _) = try await URLSession.shared.data(from: url)
                let response = try JSONDecoder().decode(AppStoreResponse.self, from: data)
                guard let storeVersion = response.results.first.map({ Version(from: $0.version) })
                else { return .none }
                // 버전 비교
                if storeVersion.major > currentVersion.major ||
                   (storeVersion.major == currentVersion.major &&
                    storeVersion.minor > currentVersion.minor) {
                    return .update(.major)
                } else if storeVersion.patch > currentVersion.patch {
                    return .update(.minor)
                }
                return .none
            },
            checkLogin: {
                do {
                    return try await authClient.validateSession()
                } catch {
                    return false
                }
            }
        )
    }
}

// MARK: - Dependencies Registration
extension DependencyValues {
    public var introClient: IntroClient {
        get { self[IntroClient.self] }
        set { self[IntroClient.self] = newValue }
    }
}
