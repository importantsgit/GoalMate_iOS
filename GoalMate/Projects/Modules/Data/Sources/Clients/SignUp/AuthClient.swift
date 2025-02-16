//
//  AuthClient.swift
//  Data
//
//  Created by Importants on 2/5/25.
//

import Dependencies
import DependenciesMacros
import Foundation
import Utils

public struct SocialLoginResponse: Equatable, Decodable {
    let credential: String
    let nonce: String
}

public struct TokenResponse: Equatable, Codable {
    let accessToken: String
    let refreshToken: String
}

public enum LoginType {
    case kakao
    case apple
    var path: String {
        switch self {
        case .kakao: return "KAKAO"
        case .apple: return "APPLE"
        }
    }
}

@DependencyClient
public struct AuthClient {
    public var kakaoLogin: () async throws -> SocialLoginResponse
    public var appleLogin: () async throws -> SocialLoginResponse
    public var authenticate: (
        _ response: SocialLoginResponse,
        _ type: LoginType
    ) async throws -> TokenResponse
    public var isLogin: () async throws -> Bool
    public var refresh: (_ token: String) async throws -> TokenResponse

    public init(
        kakaoLogin: @escaping () -> SocialLoginResponse,
        appleLogin: @escaping () -> SocialLoginResponse,
        authenticate: @escaping (
            _: SocialLoginResponse,
            _: LoginType
        ) -> TokenResponse,
        isLogin: @escaping () -> Bool,
        refresh: @escaping (
            _: String
        ) -> TokenResponse
    ) {
        self.kakaoLogin = kakaoLogin
        self.appleLogin = appleLogin
        self.authenticate = authenticate
        self.isLogin = isLogin
        self.refresh = refresh
    }
}

// MARK: - Live Implementation
extension AuthClient: DependencyKey {
    public static var liveValue: AuthClient {
        @Dependency(\.networkClient) var networkClient
        @Dependency(\.dataStorageClient) var dataStorageClient

        return .init(
            kakaoLogin: {
                let kakaoLoginService = KakaoLoginService()
                return try await kakaoLoginService.requestLogin()
            },
            appleLogin: {
                let appleLoginService = AppleLoginService()
                return try await appleLoginService.requestLogin()
            },
            authenticate: { response, type in
                let requestDTO: AuthLoginRequestDTO = .init(
                    identityToken: response.credential,
                    nonce: response.nonce,
                    provider: type.path
                )
                let endpoint = APIEndpoints.authLoginEndpoint(with: requestDTO)
                let response = try await networkClient.asyncRequest(with: endpoint)
                await dataStorageClient.setTokenInfo(.init(
                    accessToken: response.data.accessToken,
                    refreshToken: response.data.refreshToken
                ))
                return .init(
                    accessToken: response.data.accessToken,
                    refreshToken: response.data.refreshToken
                )
            },
            isLogin: {
                // await dataStorageClient.isLogin
                true
            },
            refresh: { token in
                let endpoint = APIEndpoints.refreshLoginEndpoint(refreshToken: token)
                let response = try await networkClient.asyncRequest(with: endpoint)
                guard response.code == "200"
                else { throw NetworkError.statusCodeError(code: 300) }
                await dataStorageClient.setTokenInfo(.init(
                    accessToken: response.data.accessToken,
                    refreshToken: response.data.refreshToken
                ))
                return .init(
                    accessToken: response.data.accessToken,
                    refreshToken: response.data.refreshToken
                )
            }
        )
    }

    public static var testValue = AuthClient(
        kakaoLogin: { return .init(credential: "credential", nonce: "nonce") },
        appleLogin: { return .init(credential: "credential", nonce: "nonce") },
        authenticate: { _, _ in
            return .init(accessToken: "access", refreshToken: "refresh")
        },
        isLogin: { return true },
        refresh: { _ in
            return .init(accessToken: "access", refreshToken: "refresh")
        }
    )

    public static var previewValue = AuthClient(
        kakaoLogin: { return .init(credential: "credential", nonce: "nonce") },
        appleLogin: { return .init(credential: "credential", nonce: "nonce") },
        authenticate: { _, _ in
            return .init(accessToken: "access", refreshToken: "refresh")
        },
        isLogin: { return false },
        refresh: { _ in
            return .init(accessToken: "access", refreshToken: "refresh")
        }
    )
}

// MARK: - Dependencies Registration
extension DependencyValues {
    public var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
