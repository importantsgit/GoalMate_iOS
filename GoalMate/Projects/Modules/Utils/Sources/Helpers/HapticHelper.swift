//
//  HapticHelper.swift
//  Utils
//
//  Created by Importants on 2/22/25.
//

import Foundation
import UIKit

public struct HapticManager {
    public enum HapticStyle {
        case selection    // 선택할 때
        case success     // 성공적인 액션
        case error       // 에러 발생
        case warning     // 경고
        case toggle      // 토글 동작
   
        var style: UIImpactFeedbackGenerator.FeedbackStyle {
            switch self {
            case .selection: return .light
            case .success: return .medium
            case .error: return .heavy
            case .warning: return .rigid
            case .toggle: return .soft
            }
        }
    }

    public static func impact(style: HapticManager.HapticStyle) {
        let generator = UIImpactFeedbackGenerator(style: style.style)
        generator.prepare()
        generator.impactOccurred()
    }

    public static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}
