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

public enum AuthenticationType {
    case signUp    // 회원가입
    case signIn    // 로그인
}

public enum ProviderType {
    case kakao
    case apple
    var path: String {
        switch self {
        case .kakao: return "KAKAO"
        case .apple: return "APPLE"
        }
    }
}

public enum AuthError: LocalizedError {
    case needLogin
    case invalidCode(String) // 잘못된 결과
    case failed              // 요청 실패
    public var localizedDescription: String {
        switch self {
        case .needLogin:
            return "로그인이 필요합니다."
        case let .invalidCode(code):
            return "요청이 실패했습니다. code: \(code)"
        case .failed:
            return "요청이 실패했습니다."
        }
    }
}
@DependencyClient
public struct AuthClient {
    // 소셜 로그인 + 토큰 발급
    public var loginWithKakao: () async throws -> AuthenticationType
    public var loginWithApple: () async throws -> AuthenticationType
    // 토큰 관리
    public var validateSession: () async throws -> Bool
    public var refresh: () async throws -> String
    public var checkLoginStatus: () async throws -> Bool
    public var logout: () async throws -> Void
    public var withdraw: () async throws -> Void
    init(
        loginWithKakao: @escaping () -> AuthenticationType,
        loginWithApple: @escaping () -> AuthenticationType,
        validateSession: @escaping () -> Bool,
        refresh: @escaping () -> String,
        checkLoginStatus: @escaping () -> Bool,
        logout: @escaping () -> Void,
        withdraw: @escaping () -> Void
    ) {
        self.loginWithKakao = loginWithKakao
        self.loginWithApple = loginWithApple
        self.validateSession = validateSession
        self.refresh = refresh
        self.checkLoginStatus = checkLoginStatus
        self.logout = logout
        self.withdraw = withdraw
    }
}

extension AuthClient: DependencyKey {
    public static var liveValue: AuthClient {
        @Dependency(\.networkClient) var networkClient
        @Dependency(\.dataStorageClient) var dataStorageClient
        func refreshToken() async throws -> String {
            let tokenInfo = await dataStorageClient.tokenInfo
            print(tokenInfo)
            guard tokenInfo.accessToken != nil,
                  let refreshToken = tokenInfo.refreshToken
            else {
                await dataStorageClient.setTokenInfo(nil)
                throw AuthError.needLogin
            }
            let requestDTO = RefreshTokenRequestDTO(refreshToken: refreshToken)
            let endpoint = APIEndpoints.refreshTokenEndpoint(with: requestDTO)
            let response = try await networkClient.asyncRequest(with: endpoint)
            guard response.code != "401" else {
                await dataStorageClient.setTokenInfo(nil)
                throw AuthError.needLogin
            }
            guard response.code == "200" else {
                throw AuthError.invalidCode(response.code)
            }
            let tokenResponse = TokenInfo(
                accessToken: response.data.accessToken,
                refreshToken: response.data.refreshToken
            )
            await dataStorageClient.setTokenInfo(tokenResponse)
            return response.data.accessToken
        }
        return .init(
            loginWithKakao: {
                let kakaoLoginService = KakaoLoginService()
                let socialResponse = try await kakaoLoginService.requestLogin()
                let requestDTO = AuthLoginRequestDTO(
                    identityToken: socialResponse.credential,
                    nonce: socialResponse.nonce,
                    provider: ProviderType.kakao.path
                )
                let endpoint = APIEndpoints.authLoginEndpoint(with: requestDTO)
                let response = try await networkClient.asyncRequest(with: endpoint)
                // 200: 로그인 성공, 201: 회원가입 성공
                guard response.code == "200" || response.code == "201"
                else { throw AuthError.invalidCode(response.code) }
                let tokenResponse = TokenInfo(
                    accessToken: response.data.accessToken,
                    refreshToken: response.data.refreshToken
                )
                await dataStorageClient.setTokenInfo(tokenResponse)
                return response.code == "200" ? .signIn : .signUp
            },
            loginWithApple: {
                let appleLoginService = AppleLoginService()
                let socialResponse = try await appleLoginService.requestLogin()
                let requestDTO = AuthLoginRequestDTO(
                    identityToken: socialResponse.credential,
                    nonce: socialResponse.nonce,
                    provider: ProviderType.apple.path
                )
                let endpoint = APIEndpoints.authLoginEndpoint(with: requestDTO)
                let response = try await networkClient.asyncRequest(with: endpoint)
                // 200: 로그인 성공, 201: 회원가입 성공
                guard response.code == "200" || response.code == "201"
                else { throw AuthError.invalidCode(response.code) }
                let tokenResponse = TokenInfo(
                    accessToken: response.data.accessToken,
                    refreshToken: response.data.refreshToken
                )
                await dataStorageClient.setTokenInfo(tokenResponse)
                return response.code == "200" ? .signIn : .signUp
            },
            validateSession: {
                do {
                    _ = try await refreshToken()
                    return true
                } catch {
                    print(error.localizedDescription)
                    if let error = error as? NetworkError,
                       case let .statusCodeError(code) = error,
                       code == 401 {
                        await dataStorageClient.setTokenInfo(nil)
                    }
                    return false
                }
            },
            refresh: {
                do {
                    return try await refreshToken()
                } catch {
                    if let error = error as? NetworkError,
                       case let .statusCodeError(code) = error,
                       code == 401 {
                        await dataStorageClient.setTokenInfo(nil)
                    }
                    throw AuthError.failed
                }
            },
            checkLoginStatus: {
                await dataStorageClient.tokenInfo.accessToken != nil
            },
            logout: {
                let tokenInfo = await dataStorageClient.tokenInfo
                guard let accessToken = tokenInfo.accessToken
                else {
                    await dataStorageClient.setTokenInfo(nil)
                    throw AuthError.needLogin
                }
                let endpoint = APIEndpoints.authLogoutEndpoint(accessToken: accessToken)
                let response = try await networkClient.asyncRequest(with: endpoint)
                guard response.code == "200"
                else { throw AuthError.failed }
                await dataStorageClient.setTokenInfo(nil)
            },
            withdraw: {
                let tokenInfo = await dataStorageClient.tokenInfo
                guard let accessToken = tokenInfo.accessToken
                else {
                    await dataStorageClient.setTokenInfo(nil)
                    throw AuthError.needLogin
                }
                let endpoint = APIEndpoints.withdrawEndpoint(accessToken: accessToken)
                let response = try await networkClient.asyncRequest(with: endpoint)
                guard response.code == "200"
                else { throw AuthError.failed }
                await dataStorageClient.setTokenInfo(nil)
            }
        )
    }
    public static var previewValue: AuthClient {
        return .init(
            loginWithKakao: { .signUp },
            loginWithApple: { .signIn },
            validateSession: { return true },
            refresh: { return "AccessToken" },
            checkLoginStatus: { return true },
            logout: {},
            withdraw: {}
        )
    }
    public static var testValue: AuthClient {
        return .init(
            loginWithKakao: { .signUp },
            loginWithApple: { .signIn },
            validateSession: { return true },
            refresh: { return "AccessToken" },
            checkLoginStatus: { return true },
            logout: {},
            withdraw: {}
        )
    }
}

// MARK: - Dependencies Registration
extension DependencyValues {
    public var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
