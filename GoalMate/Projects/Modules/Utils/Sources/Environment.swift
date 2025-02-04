//
//  Environment.swift
//  Utils
//
//  Created by Importants on 2/5/25.
//

import Foundation

public enum Environment {
    enum Keys {
        enum Plist {
            static let KakaoKey = "KAKAO_APP_KEY"
            static let baseURL = "BASE_URL"
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
        guard let kakaoKey = Environment.infoDictionary[Keys.Plist.KakaoKey] as? String
        else {
            fatalError("Kakao Key not set in plist for this environment")
        }
        return kakaoKey
    }()

    public static let baseURL: String = {
        guard let baseURLString = Environment.infoDictionary[Keys.Plist.baseURL] as? String
        else {
            fatalError("Base URL not set in plist for this environment")
        }
        return baseURLString
    }()
}
