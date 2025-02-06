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
        case .kakao: return "kakao"
        case .apple: return "apple"
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
    public var refresh: (_ token: String) async throws -> TokenResponse

    public init(
        kakaoLogin: @escaping () -> SocialLoginResponse,
        appleLogin: @escaping () -> SocialLoginResponse,
        authenticate: @escaping (
            _: SocialLoginResponse,
            _: LoginType
        ) -> TokenResponse,
        refresh: @escaping (
            _: String
        ) -> TokenResponse
    ) {
        self.kakaoLogin = kakaoLogin
        self.appleLogin = appleLogin
        self.authenticate = authenticate
        self.refresh = refresh
    }
}

// MARK: - Live Implementation
extension AuthClient: DependencyKey {
    public static var liveValue: AuthClient {
        print(Environment.baseURL)
        let networkService = NetworkService(
            config: NetworkConfiguration(baseURL: URL(string: Environment.baseURL)!)
        )
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
                let endPoint = APIEndPoints.authLoginEndPoint(with: requestDTO)
                let response = try await networkService.asyncRequest(with: endPoint)
                return .init(
                    accessToken: response.data.accessToken,
                    refreshToken: response.data.refreshToken
                )
            },
            refresh: { token in
                let requestDTO: RefreshLoginRequestDTO = .init(refreshToken: token)
                let endPoint = APIEndPoints.refreshLoginEndPoint(with: requestDTO)
                let response = try await networkService.asyncRequest(with: endPoint)
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
