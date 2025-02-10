//
//  LoginError.swift
//  Data
//
//  Created by Importants on 2/5/25.
//

import Foundation

public enum LoginError: Error {
    case invalidNonce
    case authFailed
    case loginFailed
    case noToken
}
