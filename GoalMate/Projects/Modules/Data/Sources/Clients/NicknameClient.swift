//
//  NicknameClient.swift
//  Data
//
//  Created by Importants on 2/7/25.
//

import Dependencies
import DependenciesMacros

@DependencyClient
public struct NicknameClient {
    public var setNickname: (String) async throws -> Void
    public var isUniqueNickname: (String) async throws -> Bool
}

extension NicknameClient: DependencyKey {
    public static var liveValue: NicknameClient {
        @Dependency(\.authClient) var authClient
        @Dependency(\.networkClient) var networkClient
        @Dependency(\.dataStorageClient) var dataStorageClient
        func executeWithTokenValidation<T>(
            action: (_ accessToken: String) async throws -> T
        ) async throws -> T {
            guard let accessToken = await dataStorageClient.tokenInfo.accessToken else {
                throw AuthError.needLogin
            }
            do {
                return try await action(accessToken)
            } catch let error as NetworkError {
                if case let .statusCodeError(code) = error,
                    code == 401 {
                    let newAccessToken = try await authClient.refresh()
                    return try await action(newAccessToken)
                }
                throw error
            }
        }
        return .init(
            setNickname: { nickname in
                try await executeWithTokenValidation { accessToken in
                    let requestDTO = SetNicknameRequestDTO(name: nickname)
                    let endpoint = APIEndpoints.setNicknameEndpoint(
                        with: requestDTO,
                        accessToken: accessToken
                    )
                    let result = try await networkClient.asyncRequest(with: endpoint)
                    await dataStorageClient.setUserInfo(
                        .init(nickname: nickname)
                    )
                }
            },
            isUniqueNickname: { nickname in
                try await executeWithTokenValidation { accessToken in
                    let requestDTO = CheckNicknameRequestDTO(name: nickname)
                    let endpoint = APIEndpoints.checkNicknameEndpoint(
                        with: requestDTO,
                        accessToken: accessToken
                    )
                    let response = try await networkClient.asyncRequest(with: endpoint)
                    guard let data = response.data
                    else { throw NetworkError.emptyData }
                    return data.isAvailable
                }
            }
        )
    }
    
    public static var previewValue: NicknameClient = .init(
        setNickname: { _ in return },
        isUniqueNickname: { _ in
            try await Task.sleep(nanoseconds: 1_000_000_000)
            return true
        }
    )
}

public extension DependencyValues {
    var nicknameClient: NicknameClient {
        get { self[NicknameClient.self] }
        set { self[NicknameClient.self] = newValue }
    }
}
