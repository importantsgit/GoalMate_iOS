//
//  UserDefault.swift
//  Data
//
//  Created by Importants on 2/10/25.
//

import Foundation
import Utils

@propertyWrapper
struct UserDefaultsWrapper<T: Codable> {
    let key: String
    let placeValue: T
    let encrypted: Bool
    private let userDefaults = UserDefaults.standard
    init(key: String, placeValue: T, encrypted: Bool = false) {
        self.key = key
        self.placeValue = placeValue
        self.encrypted = encrypted
    }
    var wrappedValue: T {
        get {
            guard let data = userDefaults.data(forKey: key)
            else { return placeValue }
            let decodingData: Data
            if encrypted {
                guard let decryptedData = AESHelper.decrypt(data)
                else { return placeValue }
                decodingData = decryptedData
            } else {
                decodingData = data
            }
            guard let value = try? JSONDecoder().decode(T.self, from: decodingData)
            else { return placeValue }
            return value
        }
        set {
            guard let encodedData = try? JSONEncoder().encode(newValue)
            else { return }     
            if encrypted {
                guard let encryptedData = AESHelper.encrypt(encodedData)
                else { return }
                userDefaults.setValue(encryptedData, forKey: key)
            } else {
                userDefaults.setValue(encodedData, forKey: key)
            }
        }
    }
}
