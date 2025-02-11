//
//  Environments.swift
//  Utils
//
//  Created by Importants on 2/5/25.
//

import Foundation
// Environment는 허용 안됨
public enum Environments {
    enum Keys {
        enum Plist {
            static let KakaoKey = "KAKAO_APP_KEY"
            static let baseURL = "BASE_URL"
            static let AESKey = "ASE_KEY"
            static let AESIV = "ASE_IV"
        }
    }

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary
        else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    public static let kakaoKey: String = {
        guard let kakaoKey = Environments.infoDictionary[Keys.Plist.KakaoKey] as? String
        else {
            fatalError("Kakao Key not set in plist for this environment")
        }
        return kakaoKey
    }()

    public static let baseURL: String = {
        guard let baseURLString = Environments.infoDictionary[Keys.Plist.baseURL] as? String
        else {
            fatalError("Base URL not set in plist for this environment")
        }
        return baseURLString
    }()

    public static let AESKey: String = {
        guard let baseURLString = Environments.infoDictionary[Keys.Plist.AESKey] as? String
        else {
            fatalError("Base URL not set in plist for this environment")
        }
        return baseURLString
    }()

    public static let AESIV: String = {
        guard let baseURLString = Environments.infoDictionary[Keys.Plist.AESIV] as? String
        else {
            fatalError("Base URL not set in plist for this environment")
        }
        return baseURLString
    }()
}

public extension Environments {
    static let TermsOfServiceURLString = "https://ash-oregano-9dc.notion.site/f97185c23c5444b4ae3796928ae7f646?pvs=74"
    static let PrivacyPolicyAgreeURLString = "https://ash-oregano-9dc.notion.site/997827990f694f63a60b06c06beb1468"
    static let qnaURLString = "https://ash-oregano-9dc.notion.site/5b001277dea44b779bd41dd11550e13c?pvs=4"
}
