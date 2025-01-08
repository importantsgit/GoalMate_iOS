//
//  SignUpView.swift
//  SignUp
//
//  Created by Importants on 1/6/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI

struct SignUpView: View {
    @State var store: StoreOf<SignUpFeature>

    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                NavigationBar(
                    leftContent: {
                        Images.logoSub
                            .resized(size: .init(width: 84, height: 32))
                    }
                )
                Spacer()
                    .frame(height: 40)
                SignUpProcessView(processType: .signUp)
                Spacer()
                    .frame(height: 82)
                Images.loginBanner
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)

                Spacer()
                VStack(spacing: 12) {
                    RoundedButton(
                        buttonType: FilledStyle(backgroundColor: Colors.kakaoBg),
                        height: 54
                    ) {
                        store.send(.signUpButtonTapped(.kakao))
                    } label: {
                        Images.kakaoLogo
                            .resized(length: 16)
                        Text("카카오로 시작하기")
                            .pretendard(.semiBold, size: 16, color: Colors.kakaoText)
                    }
                    RoundedButton(
                        buttonType: FilledStyle(backgroundColor: .black),
                        height: 54
                    ) {
                        store.send(.signUpButtonTapped(.apple))
                    } label: {
                        HStack(spacing: 5) {
                            Text("")
                            Text("Apple로 시작하기")
                        }
                        .pretendard(.semiBold, size: 16, color: .white)
                    }
                }
            }
            .setMargin()
            .loading(isLoading: $store.isLoading)
        }

    }
}

@available(iOS 17.0, *)
#Preview {
    SignUpView(
        store: Store(
            initialState: SignUpFeature.State.init(),
            reducer: {
                SignUpFeature()
            }
        )
    )
}
