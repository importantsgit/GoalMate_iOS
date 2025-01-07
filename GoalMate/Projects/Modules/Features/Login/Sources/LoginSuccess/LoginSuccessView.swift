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
            NavigationBar(
                leftContent: {
                    Images.logoSub
                        .resized(size: .init(width: 84, height: 32))
                }
            )
            Spacer()
                .frame(height: 40)
            LoginProcessView(processType: .complete)
            Spacer()
                .frame(height: 82)
            Images.loginSuccessBanner
                .resized(length: 320)
                .overlay {
                    VStack {
                        Spacer()
                            .frame(height: 44)
                        Text("축하해요\n\(store.nickName)님,\n바로 첫 목표를 시작해보세요!")
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            .pretendard(.semiBold, size: 18, color: Colors.gray900)
                        Spacer()
                    }
                }
            Spacer()
            RoundedButton(
                buttonType: FilledStyle(backgroundColor: Colors.primary),
                height: 54
            ) {
                store.send(.startButtonTapped)
            } label: {
                Text("골메이트 시작하기")
                    .pretendard(
                        .semiBold,
                        size: 16,
                        color: .black
                    )
            }
        }
        .setMargin()
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
