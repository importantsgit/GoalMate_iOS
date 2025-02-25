//
//  DataStorageService.swift
//  Data
//
//  Created by Importants on 2/10/25.
//

public struct UserInfo: Codable {
    var nickname: String?
}

public struct TokenInfo: Codable {
    var accessToken: String?
    var refreshToken: String?
}

public actor DataStorageService {
    enum Key: String {
        case user
        case token
        var value: String { self.rawValue }
        var needsEncryption: Bool {
            switch self {
            case .token:
                return true
            default:
                return false
            }
        }
    }
    @UserDefaultsWrapper(
        key: Key.user.value,
        placeValue: .init(),
        encrypted: Key.user.needsEncryption
    )
    var userInfo: UserInfo
    @UserDefaultsWrapper(
        key: Key.token.value,
        placeValue: .init(),
        encrypted: Key.token.needsEncryption
    )
    var tokenInfo: TokenInfo
    var isLogin: Bool = false
    var isShowRemainingTodosNotice: Bool = false
    
    public func setUserInfo(_ userInfo: UserInfo) {
        self.userInfo = userInfo
    }
    public func setTokenInfo(_ tokenInfo: TokenInfo?) {
        guard let tokenInfo
        else {
            self.tokenInfo = .init()
            return
        }
        self.isLogin = true
        self.tokenInfo = tokenInfo
    }
    public func setShowRemainingTodosNotice(_ isShow: Bool) {
        self.isShowRemainingTodosNotice = isShow
    }
}
