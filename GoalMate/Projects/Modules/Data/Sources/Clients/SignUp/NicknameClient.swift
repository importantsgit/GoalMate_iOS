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
    public init(
        setNickname: @escaping (String) -> Void,
        isUniqueNickname: @escaping (String) -> Bool
    ) {
        self.setNickname = setNickname
        self.isUniqueNickname = isUniqueNickname
    }
}

extension NicknameClient: DependencyKey {
    public static var liveValue: NicknameClient {
        @Dependency(\.networkClient) var networkClient
        @Dependency(\.dataStorageClient) var dataStorageClient
        return .init(
            setNickname: { nickName in
                guard let accessToken = await dataStorageClient.tokenInfo.accessToken
                else { throw NetworkError.emyptyAccessToken }
                let requestDTO: SetNicknameRequestDTO = .init(name: nickName)
                let endpoint = APIEndpoints.setNicknameEndpoint(
                    with: requestDTO,
                    accessToken: accessToken
                )
                _ = try await networkClient.asyncRequest(with: endpoint)
                await dataStorageClient.setUserInfo(
                    .init(nickname: nickName)
                )
            },
            isUniqueNickname: { nickName in
                guard let accessToken = await dataStorageClient.tokenInfo.accessToken
                else { throw NetworkError.emyptyAccessToken }
                let requestDTO: checkNicknameRequestDTO = .init(name: nickName)
                let endpoint = APIEndpoints.checkNicknameEndpoint(
                    with: requestDTO,
                    accessToken: accessToken
                )
                let response = try await networkClient.asyncRequest(with: endpoint)
                return response.code == "200" // duplicated
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
