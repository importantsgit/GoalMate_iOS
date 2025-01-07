//
//  LoginSuccessView.swift
//  Login
//
//  Created by Importants on 1/7/25.
//

import Common
import ComposableArchitecture
import SwiftUI

struct LoginSuccessView: View {
    @State var store: StoreOf<LoginSuccessFeature>
    var body: some View {
        VStack {
            HStack {
                CommonImages.logoSub
                    .resized(length: 16)
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
                                        .pretendard(.semiBold, size: 14, color: .black)
                                    VStack(spacing: 16) {
                                        Spacer()
                                            .frame(height: 24)
                                        Text("회원가입")
                                            .pretendard(.regular, size: 12, color: .gray)
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
                                        .pretendard(.semiBold, size: 14, color: .black)
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
                                        .pretendard(.semiBold, size: 14, color: .black)
                                }
                            )
                            .frame(width: 24, height: 24)
                    }

                }
            }
            Spacer()
                .frame(height: 82)
            CommonImages.loginSuccessBanner
                .resized(length: 320)
                .overlay {
                    VStack {
                        Spacer()
                            .frame(height: 44)
                        Text("축하해요\n\(store.nickName)님,\n바로 첫 목표를 시작해보세요!")
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            .pretendard(.semiBold, size: 18, color: .black)
                        Spacer()
                    }
                }
            Spacer()
            Button {
                // TODO: Apple 로그인
            } label: {
                HStack(spacing: 5) {
                    Spacer()
                    Text("골메이트 시작하기")
                    Spacer()
                }
                .pretendard(.semiBold, size: 16, color: .white)
                .frame(height: 54)
                .background(.black)
                .clipShape(.capsule)
            }
            Spacer()
                .frame(height: 16)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    LoginSuccessView(
        store: Store(
            initialState: LoginSuccessFeature.State.init(),
            reducer: {
                LoginSuccessFeature()
            }
        )
    )
}
