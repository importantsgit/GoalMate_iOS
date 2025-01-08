//
//  SignUpSuccessView.swift
//  SignUp
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI

struct SignUpSuccessView: View {
    @State var store: StoreOf<SignUpSuccessFeature>
    var body: some View {
        WithPerceptionTracking {
            VStack {
                NavigationBar(
                    leftContent: {
                        Images.logoSub
                            .resized(size: .init(width: 84, height: 32))
                    }
                )
                Spacer()
                    .frame(height: 40)
                SignUpProcessView(processType: .complete)
                Spacer()
                    .frame(height: 82)
                Images.loginSuccessBanner
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
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
}

#Preview {
    SignUpSuccessView(
        store: Store(
            initialState: SignUpSuccessFeature.State.init(
                nickName: "hello"
            ),
            reducer: {
                SignUpSuccessFeature()
            }
        )
    )
}
