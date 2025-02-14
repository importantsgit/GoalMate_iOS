//
//  NetworkError.swift
//  Data
//
//  Created by Importants on 2/5/25.
//

import Foundation

public enum NetworkError: LocalizedError {
    case unKnownedError
    case URLError
    case statusCodeError(code: Int)
    case invalidHTTPBody
    case invaildResponse
    case invalidFormat
    case emyptyAccessToken
    case invalidAccessToken

    public var errorDescription: String? {
       switch self {
       case .unKnownedError:
           return "알 수 없는 오류가 발생했습니다. 다시 시도해주세요."
       case .URLError:
           return "잘못된 URL입니다."
       case .statusCodeError(let code):
           return "서버 응답 코드 오류: \(code)"
       case .invalidHTTPBody:
           return "잘못된 요청 데이터입니다."
       case .invaildResponse:
           return "서버로부터 잘못된 응답을 받았습니다."
       case .invalidFormat:
           return "데이터 형식이 올바르지 않습니다."
       case .emyptyAccessToken:
           return "액세스 토큰이 존재하지 않습니다."
       case .invalidAccessToken:
           return "액세스 토큰이 유효하지 않습니다."
       }
    }
}
