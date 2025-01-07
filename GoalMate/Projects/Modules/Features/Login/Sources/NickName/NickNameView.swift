//
//  NickNameView.swift
//  Login
//
//  Created by Importants on 1/7/25.
//

import Common
import ComposableArchitecture
import SwiftUI

struct NickNameView: View {
    @State var store: StoreOf<NickNameFeature>
    
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
                            .overlay(
                                ZStack {
                                    Text("1")
                                        .pretendard(.semiBold, size: 14, color: .black)
                                }
                            )
                            .frame(width: 24, height: 24)
                        Circle()
                            .fill(.green)
                            .frame(width: 24, height: 24)
                            .overlay {
                                ZStack {
                                    Text("2")
                                        .pretendard(.semiBold, size: 14, color: .black)
                                    VStack(spacing: 16) {
                                        Spacer()
                                            .frame(height: 24)
                                        Text("닉네임 설정")
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
                                    Text("3")
                                        .pretendard(.semiBold, size: 14, color: .black)
                                }
                            )
                            .frame(width: 24, height: 24)
                    }
                }
            }
            Spacer()
                .frame(height: 120)
            Text("앞으로 어떻게 불러드릴까요?")
                .pretendard(.semiBold, size: 18, color: .black)
            Spacer()
                .frame(height: 44)
            VStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(lineWidth: 2)
                        .foregroundStyle(.gray)
                    TextField(
                        "아이디를 입력해주세요",
                        text: $store.nickname)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
                .frame(height: 44)
                HStack {
                    Text("최소 2글자, 최대 5글자로 입력해주세요.")
                        .pretendard(.regular, size: 14, color: .black)
                    Spacer()
                }
                Spacer()
                Button {
                    // TODO: Apple 로그인
                } label: {
                    HStack {
                        Spacer()
                        Text("골메이트 시작하기")
                        Spacer()
                    }
                    .pretendard(.semiBold, size: 16, color: .white)
                    .frame(height: 54)
                    .background(.green)
                    .clipShape(.capsule)
                }
                Spacer()
                    .frame(height: 16)
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    NickNameView(
        store: Store(
            initialState: NickNameFeature.State.init(),
            reducer: {
                NickNameFeature()
            })
    )
}
