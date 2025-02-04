//
//  NetworkDTO.swift
//  Data
//
//  Created by Importants on 2/5/25.
//

import Foundation

public struct AuthLoginRequestDTO: Codable {
    let identityToken: String
    let nonce: String
    let provider: String
    enum CodingKeys: String, CodingKey {
        case identityToken = "identity_token"
        case nonce, provider
    }
}

public struct AuthLoginResponseDTO: Codable {
    let status: String
    let code: String
    let message: String
    let data: Response
    struct Response: Codable {
        let accessToken: String
        let refreshToken: String
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case refreshToken = "refresh_token"
        }
    }
}

public struct RefreshLoginRequestDTO: Codable {
    let refreshToken: String
    enum CodingKeys: String, CodingKey {
        case refreshToken = "refresh_token"
    }
}
