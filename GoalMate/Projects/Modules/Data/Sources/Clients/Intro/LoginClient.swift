//
//  LoginClient.swift
//  Data
//
//  Created by Importants on 2/11/25.
//

import Dependencies
import DependenciesMacros
import Foundation
import Utils

@DependencyClient
public struct LoginClient {
    public var login: () async throws -> Bool
    public init(login: @escaping () -> Bool) {
        self.login = login
    }
}

// MARK: - Live Implementation
extension LoginClient: DependencyKey {
    public static var liveValue: LoginClient {
        @Dependency(\.dataStorageClient) var dataStorageClient
        @Dependency(\.networkClient) var networkClient
        @Dependency(\.authClient) var authClient
        return .init(
            login: {
                let token = await dataStorageClient.tokenInfo
                do {
                    guard let accessToken = token.accessToken
                    else { throw LoginError.noToken }
                    let requestDTO = LoginRequestDTO(
                        accessToken: accessToken
                    )
//                    let endpoint = APIEndpoints.loginEndpoint(with: requestDTO)
//                    let response = try await networkClient.asyncRequest(with: endpoint)
                    return true //response.isSuccess
                } catch {
                    // 로그인 실패시 토큰 갱신 시도
                    guard let refreshToken = token.refreshToken
                    else { throw LoginError.noToken }
                    let newToken = try await authClient.refresh(refreshToken)
                    let requestDTO = RefreshLoginRequestDTO(
                        refreshToken: newToken.refreshToken
                    )
//                    let endpoint = APIEndpoints.loginEndpoint(with: requestDTO)
//                    let response = try await networkClient.asyncRequest(with: endpoint)
                    return true //response.isSuccess
                }
            }
        )
    }

    public static var testValue = LoginClient(
        login: {  true }
    )

    public static var previewValue = LoginClient(
        login: {  true }
    )
}

// MARK: - Dependencies Registration
extension DependencyValues {
    public var loginClient: LoginClient {
        get { self[LoginClient.self] }
        set { self[LoginClient.self] = newValue }
    }
}
