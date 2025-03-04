//
//  SignUpFeature+Define.swift
//  FeatureSignUp
//
//  Created by 이재훈 on 2/19/25.
//

import Data
import FeatureCommon
import Foundation
import SwiftUI

extension SignUpFeature {
    public enum AuthenticationResult {
        case success(AuthenticationType)
        case networkError
        case failed
    }
    public enum NicknameSubmitResult {
        case success(String)
        case networkError
        case failed
    }
    public enum NicknameCheckResult {
        case success(String)
        case duplicateName
        case networkError
        case unknown
        static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.success, .success):
                return true
            case (.duplicateName, .duplicateName):
                return true
            case (.networkError, .networkError):
                return true
            case (.unknown, .unknown):
                return true
            default:
                return false
            }
        }
    }
    public enum GetNicknameResult {
        case success(String)
        case networkError
        case failed
    }
    public enum SignUpProvider {
        case apple
        case kakao
    }
    public enum TextFieldState {
        case idle
        case editing
        case duplicate
        case invalid
        case valid
        public var message: String {
            switch self {
            case .idle:
                return "2~5글자 닉네임을 입력해주세요"
            case .editing:
                return ""
            case .duplicate:
                return "이미 있는 닉네임이에요 :("
            case .invalid:
                return "2~5글자 닉네임을 입력해주세요."
            case .valid:
                return "사용 가능한 닉네임이에요 :)"
            }
        }
        public var color: Color {
            switch self {
            case .duplicate, .invalid:
                return Colors.error
            case .valid:
                return Colors.focused
            default :
                return Colors.grey400
            }
        }
        public var textColor: Color {
            switch self {
            case .duplicate, .invalid:
                return Colors.error
            case .valid:
                return Colors.focused
            default :
                return Colors.grey900
            }
        }
        public var messageColor: Color {
            switch self {
            case .duplicate, .invalid:
                return Colors.error
            case .valid:
                return Colors.focused
            default :
                return Colors.grey600
            }
        }
    }
}
