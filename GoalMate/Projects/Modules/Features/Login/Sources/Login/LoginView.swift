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
    let store: StoreOf<LoginFeature>

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(asset: CommonAsset.Assets.logoSub)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 84, height: 32)
                Spacer()
            }
            Spacer()
                .frame(height: 40)
            HStack(spacing: 0) {
                ZStack {
                    HStack {
                        Rectangle()
                            .fill(.green)
                            .frame(width: 75, height: 8)
                        Rectangle()
                            .fill(.green)
                            .frame(width: 75, height: 8)
                    }
                    HStack(spacing: 51) {
                        Circle()
                            .fill(.green)
                            .frame(width: 24, height: 24)
                            .overlay {
                                ZStack {
                                    Text("1")
                                        .font(
                                            CommonFontFamily.Pretendard.semiBold.swiftUIFont(size: 14)
                                        )
                                        .foregroundStyle(.black)
                                    VStack(spacing: 16) {
                                        Spacer()
                                            .frame(height: 24)
                                        Text("회원가입")
                                            .font(
                                                CommonFontFamily.Pretendard.regular.swiftUIFont(size: 12)
                                            )
                                            .foregroundStyle(.gray)
                                            .frame(width: 100)
                                    }
                                    .offset(CGSize(width: 0, height: 6))
                                }

                            }
                        Circle()
                            .fill(Color.white)
                            .overlay(
                                ZStack {
                                    Circle()
                                        .stroke(Color.blue, lineWidth: 2)
                                    Text("2")
                                        .font(
                                            CommonFontFamily.Pretendard.semiBold.swiftUIFont(size: 14)
                                        )
                                        .foregroundStyle(.black)
                                }
                            )
                            .frame(width: 24, height: 24)
                        Circle()
                            .fill(Color.white)
                            .overlay(
                                ZStack {
                                    Circle()
                                        .stroke(Color.blue, lineWidth: 2)
                                    Text("3")
                                        .font(
                                            CommonFontFamily.Pretendard.semiBold.swiftUIFont(size: 14)
                                        )
                                        .foregroundStyle(.black)
                                }
                            )
                            .frame(width: 24, height: 24)
                    }

                }
            }
            Spacer()
                .frame(height: 82)
            Image(asset: CommonAsset.Assets.loginBanner)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 320, height: 320)
            Spacer()
                .frame(height: 72)
            VStack(spacing: 12) {
                Button {
                   // TODO: 카카오 로그인
                } label: {
                    HStack(spacing: 5) {
                        Spacer()
                        Image(asset: CommonAsset.Assets.kakaoLogo)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 16, height: 16)
                        Text("카카오로 시작하기")
                        Spacer()
                    }
                    .font(
                        CommonFontFamily.Pretendard.semiBold.swiftUIFont(size: 16)
                    )
                    .foregroundStyle(.black) // FIXME:
                    .frame(height: 54)
                    .background(.yellow) // FIXME:
                    .clipShape(.capsule)
                }
                Button {
                    // TODO: Apple 로그인
                } label: {
                    HStack(spacing: 5) {
                        Spacer()
                        Text("")
                        Text("Apple로 시작하기")
                        Spacer()
                    }
                    .font(
                        CommonFontFamily.Pretendard.semiBold.swiftUIFont(size: 16)
                    )
                    .foregroundStyle(.white)
                    .frame(height: 54)
                    .background(.black)
                    .clipShape(.capsule)
                }
            }
            Spacer()
                .frame(height: 44)
        }
        .padding(.horizontal, 20)
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
