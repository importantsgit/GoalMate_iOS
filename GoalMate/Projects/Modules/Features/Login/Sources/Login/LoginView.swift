//
//  LoginView.swift
//  Login
//
//  Created by Importants on 1/6/25.
//

import Common
import ComposableArchitecture
import SwiftUI

struct LoginView: View {
    @State var store: StoreOf<LoginFeature>

    public var body: some View {
        VStack(spacing: 0) {
            NavigationBar(
                leftContent: {
                    CommonImages.logoSub
                        .resized(size: .init(width: 84, height: 32))
                }
            )
            Spacer()
                .frame(height: 40)
            LoginProcessView()
            Spacer()
                .frame(height: 82)
            CommonImages.loginBanner
                .resized(length: 320)
            Spacer()
                .frame(height: 72)
            VStack(spacing: 12) {
                RoundedButton(
                    buttonType: FilledStyle(backgroundColor: .yellow),
                    height: 54
                ) {
                    print("hello")
                } label: {
                    CommonImages.kakaoLogo
                        .resized(length: 16)
                    Text("카카오로 시작하기")
                        .pretendard(.semiBold, size: 16, color: .black) // FIXME:
                }
                RoundedButton(
                    buttonType: FilledStyle(backgroundColor: .black),
                    height: 54
                ) {
                    print("hello")
                } label: {
                    HStack(spacing: 5) {
                        Text("")
                        Text("Apple로 시작하기")
                    }
                    .pretendard(.semiBold, size: 16, color: .white) // FIXME:
                }
            }
        }
        .setMargin()
    }
}

@available(iOS 17.0, *)
#Preview {
    LoginView(
        store: Store(
            initialState: LoginFeature.State.init(),
            reducer: {
                LoginFeature()
            }
        )
    )
}
