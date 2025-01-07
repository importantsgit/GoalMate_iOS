//
//  Extension+Color.swift
//  Common
//
//  Created by 이재훈 on 1/7/25.
//

import SwiftUI

public extension CommonColors {
    static let logoSub = Asset.Assets.logoSub.swiftUIImage
    static let check = Asset.Assets.check.swiftUIImage
    static let kakaoLogo = Asset.Assets.kakaoLogo.swiftUIImage
    static let loginBanner = Asset.Assets.loginBanner.swiftUIImage
    static let loginSuccessBanner = Asset.Assets.loginSuccessBanner.swiftUIImage
}

public extension Color {
    /**
     HEX 코드를 사용하여 SwiftUI의 `Color` 객체를 생성하는 초기화 메서드입니다.
     
     - Parameters:
     - hex: 색상을 나타내는 16진수 문자열 (예: `"#FFFFFF"`, `"FFFFFF"`)
     - opacity: 색상의 투명도를 지정하는 값. 기본값은 `1.0`이며, `0.0`에서 `1.0` 사이의 값을 사용합니다.
     
     - Important:
     - `hex` 문자열은 6자리 16진수 형식이어야 하며, 선택적으로 `#` 접두사를 포함할 수 있습니다.
     - `hex` 문자열이 유효하지 않을 경우 프로그램이 종료됩니다. (Assertion 및 Fatal Error)
     
     - Usage:
     ```swift
     let whiteColor = Color(hex: "#FFFFFF") // 불투명한 흰색
     let semiTransparentBlack = Color(hex: "000000", opacity: 0.5) // 반투명한 검정색
     ```
     
     - Precondition:
     - `hex`는 공백 없이 6자리여야 합니다. (`"#RRGGBB"` 또는 `"RRGGBB"`)
     - `opacity`는 `0.0` 이상 `1.0` 이하의 값이어야 합니다.
     
     - Note:
     - 유효하지 않은 HEX 코드가 제공되면 에러 메시지를 출력하며 실행이 중단됩니다.
     
     - Throws:
     - `fatalError`: HEX 코드가 유효하지 않거나 변환이 실패할 경우 발생합니다.
     */
    init(hex: String, opacity: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        ).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        guard Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        else { fatalError("InvaildColor > hex: \(hex), opacity: \(opacity)") }
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            opacity: min(1, max(opacity, 0))
        )
    }
}
