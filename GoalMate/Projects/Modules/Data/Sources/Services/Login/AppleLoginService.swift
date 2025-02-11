//
//  AppleLoginManager.swift
//  Data
//
//  Created by Importants on 2/5/25.
//

import AuthenticationServices
import Foundation

public protocol AppleLoginServiceInterface {
    func requestLogin() async throws -> SocialLoginResponse
}

final class AppleLoginService: NSObject, AppleLoginServiceInterface {
    var continuation: CheckedContinuation<SocialLoginResponse, Error>?
    var nonce: String?
    override init() {
        super.init()
    }
    public func requestLogin() async throws -> SocialLoginResponse {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        nonce = generateNonce()
        request.nonce = self.nonce
        let controller = ASAuthorizationController(
            authorizationRequests: [request]
        )

        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()

        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
        }
    }

    private func generateNonce() -> String {
        // 초기 설정
        let length = 32
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        // 난수 생성
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
}

extension AppleLoginService: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let window = scene?.windows.first
        return window ?? UIWindow()
    }
}

extension AppleLoginService: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        print("Sign in with Apple failed: \n \(error.localizedDescription)")
        continuation?.resume(throwing: LoginError.loginFailed)
    }
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential
        else { return }
        let code = appleIDCredential.identityToken
        let authorizationCode = appleIDCredential.authorizationCode
        let userIdentifier = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let email = appleIDCredential.email
        guard let continuation
        else { return }
        guard let nonce = nonce
        else {
            self.continuation?.resume(
                throwing: LoginError.invalidNonce
            )
            return
        }
        if let token = code,
           let string = String(data: token, encoding: .utf8) {
            decodeIDToken(string)
            continuation.resume(
                returning: SocialLoginResponse(credential: string, nonce: nonce)
            )
        } else {
            continuation.resume(throwing: LoginError.loginFailed)
        }
        return
    }
    func decodeIDToken(_ idToken: String) {
        // 1. "."으로 세 부분 분리 (헤더.페이로드.서명)
        let segments = idToken.components(separatedBy: ".")
        // 2. 헤더 디코딩 (첫 번째 부분)
        if let headerData = base64UrlDecode(segments[0]),
           let header = try? JSONSerialization.jsonObject(
            with: headerData,
            options: []
           ) as? [String: Any] {
            print("=== Header ===")
            print("알고리즘(alg):", header["alg"] ?? "")      // RS256
            print("토큰 타입(typ):", header["typ"] ?? "")     // JWT
            print("키 ID(kid):", header["kid"] ?? "")         // 공개키 ID
        }
        // 3. 페이로드 디코딩 (두 번째 부분)
        if let payloadData = base64UrlDecode(segments[1]),
           let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] {
            print("\n=== Payload ===")
            print("발급자(iss):", payload["iss"] ?? "")           // https://kauth.kakao.com
            print("대상 앱(aud):", payload["aud"] ?? "")          // 앱 키
            print("사용자 ID(sub):", payload["sub"] ?? "")        // 회원번호
            if let iat = payload["iat"] as? TimeInterval {
                print("발급시간(iat):", Date(timeIntervalSince1970: iat))
            }
            if let exp = payload["exp"] as? TimeInterval {
                print("만료시간(exp):", Date(timeIntervalSince1970: exp))
            }
            if let authTime = payload["auth_time"] as? TimeInterval {
                print("인증시간(auth_time):", Date(timeIntervalSince1970: authTime))
            }
            print("논스값(nonce):", payload["nonce"] ?? "")
            print("닉네임:", payload["nickname"] ?? "없음")
            print("프로필사진:", payload["picture"] ?? "없음")
            print("이메일:", payload["email"] ?? "없음")
        }
        // 4. 서명 부분은 백엔드에서 검증해야 함
        print("\n=== Signature ===")
        print("서명:", segments[2])
    }
    // base64URL 디코딩 함수
    func base64UrlDecode(_ base64Url: String) -> Data? {
        var base64 = base64Url
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        while base64.count % 4 != 0 {
            base64.append("=")
        }
        return Data(base64Encoded: base64)
    }
}
