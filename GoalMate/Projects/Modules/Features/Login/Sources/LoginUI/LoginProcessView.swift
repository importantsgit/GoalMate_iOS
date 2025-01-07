//
//  LoginProcessView.swift
//  Login
//
//  Created by 이재훈 on 1/7/25.
//

import SwiftUI

internal struct LoginProcessView: View {
    enum ProcessType {
        case signUp
        case nickname
        case complete
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ZStack {
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(.green)
                        .frame(height: 8)
                    Rectangle()
                        .fill(.green)
                        .frame(height: 8)
                }
                .padding(.horizontal, 12)
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
    }

    private var circle: some View {
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
    }
}



@available(iOS 17.0, *)
#Preview {
    LoginProcessView()
        .frame(width: 175)
}

