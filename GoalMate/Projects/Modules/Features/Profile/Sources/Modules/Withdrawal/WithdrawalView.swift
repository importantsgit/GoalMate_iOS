//
//  WithdrawalView.swift
//  FeatureProfile
//
//  Created by Importants on 2/4/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI
import Utils

public struct WithdrawalView: View {
    @State var store: StoreOf<WithdrawalFeature>
    public init(store: StoreOf<WithdrawalFeature>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                NavigationBar(
                    leftContent: {
                        Button {
                            store.send(.backButtonTapped)
                        } label: {
                            Images.back
                                .resized(length: 24)
                                .frame(width: 48, height: 48)
                        }

                    },
                    centerContent: {
                        Text("탈퇴하기")
                            .pretendardStyle(.semiBold, size: 20, color: Colors.grey900)
                    }
                )
                .frame(height: 64)
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                            .frame(height: 28)
                        Text("정말 탈퇴 하시겠습니까?")
                            .pretendardStyle(.semiBold, size: 20, color: Colors.grey900)
                        Spacer()
                            .frame(height: 16)
                        Text("회원 탈퇴 시 사용한 계정을 복구할 수 없어\n이전에 진행한 목표가 전부 사라집니다.")
                            .pretendardStyle(.regular, size: 14, color: Colors.grey900)
                        Spacer()
                            .frame(height: 8)
                        Text("그래도 탈퇴를 원하시면 해당 글자를 입력해주세요.")
                            .pretendardStyle(.regular, size: 14, color: Colors.grey900)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    WithdrawalView(
        store: .init(
            initialState: .init()
        ) {
            WithdrawalFeature()
        }
    )
}
