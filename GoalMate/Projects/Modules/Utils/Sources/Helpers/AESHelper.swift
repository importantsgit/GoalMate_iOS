//
//  AESHelper.swift
//  Utils
//
//  Created by Importants on 2/10/25.
//

import CommonCrypto
import Foundation

public struct AESHelper {
    private static let KEY: String = Environments.AESKey
    private static let AESIV: String = Environments.AESIV

    /// AES-256 암호화
    public static func encrypt(_ data: Data) -> Data? {
        return crypt(data: data, key: KEY, iv: AESIV, option: CCOperation(kCCEncrypt))
    }

    /// AES-256 복호화
    public static func decrypt(_ data: Data) -> Data? {
        return crypt(data: data, key: KEY, iv: AESIV, option: CCOperation(kCCDecrypt))
    }

    /// AES 암호화 & 복호화 수행
    private static func crypt(
        data: Data,
        key: String,
        iv: String,
        option: CCOperation
    ) -> Data? {
        guard let keyData = key.data(using: .utf8),
              let ivData = iv.data(using: .utf8) else { return nil }

        let keyLength = kCCKeySizeAES256
        let dataLength = data.count
        let bufferSize = dataLength + kCCBlockSizeAES128
        var buffer = Data(count: bufferSize)

        var numBytesEncrypted: size_t = 0

        let cryptStatus = buffer.withUnsafeMutableBytes { bufferBytes in
            data.withUnsafeBytes { dataBytes in
                keyData.withUnsafeBytes { keyBytes in
                    ivData.withUnsafeBytes { ivBytes in
                        CCCrypt(
                            option,                    // 암호화 or 복호화
                            CCAlgorithm(kCCAlgorithmAES), // AES 알고리즘
                            CCOptions(kCCOptionPKCS7Padding), // 패딩 적용
                            keyBytes.baseAddress,      // 키 값
                            keyLength,                 // 키 길이
                            ivBytes.baseAddress,       // IV 값
                            dataBytes.baseAddress,     // 입력 데이터
                            dataLength,                // 입력 데이터 길이
                            bufferBytes.baseAddress,   // 출력 데이터 버퍼
                            bufferSize,                // 출력 버퍼 크기
                            &numBytesEncrypted         // 암호화된 바이트 수
                        )
                    }
                }
            }
        }

        guard cryptStatus == kCCSuccess else { return nil }
        return buffer.prefix(numBytesEncrypted) // 결과 데이터 반환
    }
}
