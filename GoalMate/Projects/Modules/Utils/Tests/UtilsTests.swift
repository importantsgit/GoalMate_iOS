import Foundation
@testable import Utils
import XCTest

final class GoalMateTests: XCTestCase {
    func testAESEncryptionAndDecryption() {
        // Given: 암호화할 원본 데이터
        let originalString = "Hello, AES Encryption!"
        let originalData = originalString.data(using: .utf8)!

        // When: AES 암호화 수행
        guard let encryptedData = AESHelper.encrypt(originalData) else {
            XCTFail("Encryption failed")
            return
        }

        // Then: AES 복호화 수행 & 원본 데이터와 비교
        guard let decryptedData = AESHelper.decrypt(encryptedData),
              let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            XCTFail("Decryption failed")
            return
        }
        
        XCTAssertEqual(originalString, decryptedString, "Decrypted text should match the original text")
    }
    
    func testEncryptionProducesDifferentOutput() {
        // Given: 동일한 원본 문자열
        let originalString = "Sensitive Data"
        let originalData = originalString.data(using: .utf8)!
        
        // When: 두 번 암호화 수행
        guard let encryptedData1 = AESHelper.encrypt(originalData),
              let encryptedData2 = AESHelper.encrypt(originalData) else {
            XCTFail("Encryption failed")
            return
        }
        
        // Then: 두 번 암호화된 값이 다른지 확인 (IV 값이 다르면 다르게 나와야 함)
        XCTAssertNotEqual(
            encryptedData1,
            encryptedData2,
            "Encryption should produce different outputs due to unique IV"
        )
    }
    
    func testDecryptionWithIncorrectData() {
        // Given: 잘못된 암호화 데이터
        let invalidData = "Invalid Data".data(using: .utf8)!
        
        // When: 복호화 시도
        let decryptedData = AESHelper.decrypt(invalidData)
        
        // Then: 복호화 실패 여부 확인
        XCTAssertNil(decryptedData, "Decryption should fail for invalid encrypted data")
    }
}
