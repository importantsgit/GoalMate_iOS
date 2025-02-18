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
    enum FocusableField: Hashable {
        case nickname
    }
    @Perception.Bindable var store: StoreOf<WithdrawalFeature>
    @FocusState private var focusedField: FocusableField?
    public init(store: StoreOf<WithdrawalFeature>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                NavigationBar(
                    leftContent: {
                        Button {
                            store.send(.view(.backButtonTapped))
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
                            .pretendardStyle(
                                .semiBold,
                                size: 20,
                                color: Colors.grey900
                            )
                        Spacer()
                            .frame(height: 16)
                        Text("회원 탈퇴 시 사용한 계정을 복구할 수 없어\n이전에 진행한 목표가 전부 사라집니다.")
                            .pretendardStyle(
                                .regular,
                                size: 14,
                                color: Colors.grey900
                            )
                        Spacer()
                            .frame(height: 8)
                        Text("그래도 탈퇴를 원하시면 해당 글자를 입력해주세요.")
                            .pretendardStyle(
                                .regular,
                                size: 14,
                                color: Colors.grey900
                            )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                        .frame(height: 30)
                    textField
                }
                .padding(.horizontal, 20)
                Spacer()
                if store.keyboardHeight > 0 {
                    VStack(spacing: 0) {
                        HStack(spacing: 10) {
                            Button {
                                store.send(.view(.backButtonTapped))
                            } label: {
                                Text("뒤로가기")
                                    .pretendard(.regular, size: 16)
                                    .frame(width: 154, height: 44)
                                    .background(.white)
                                    .clipShape(.capsule)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 22)
                                            .stroke(lineWidth: 1)
                                            .foregroundStyle(Colors.grey400)
                                    }
                            }
                            Button {
                                store.send(.view(.confirmButtonTapped))
                            } label: {
                                Text("탈퇴하기")
                                    .pretendard(
                                        .regular,
                                        size: 16,
                                        color: store.isSubmitEnabled ?
                                            .black :
                                            .white
                                    )
                                    .frame(width: 154, height: 44)
                                    .background(
                                        store.isSubmitEnabled ?
                                            Colors.primary :
                                            Colors.grey300
                                    )
                                    .clipShape(.capsule)
                            }
                            .disabled(store.isSubmitEnabled == false)
                        }
                        Spacer()
                            .frame(height: 16)
                    }
                    .ignoresSafeArea(.keyboard)
                }
            }
            .toast(state: $store.toastState)
            .task {
                store.send(.viewCycling(.onAppear))
                focusedField = .nickname
            }
        }
    }
    @ViewBuilder
    var textField: some View {
        WithPerceptionTracking {
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(Colors.grey400)
                HStack {
                    TextField(
                        "",
                        text: .init(get: { store.inputText },
                                  set: {
                                      store.send(.view(.nicknameTextInputted($0)))
                                  }),
                        prompt: Text("탈퇴")
                            .foregroundColor(Colors.grey400)
                    )
                    .pretendard(
                        .regular,
                        size: 16,
                        color: Colors.grey900
                    )
                    .labelsHidden()
                    .focused($focusedField, equals: .nickname)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
            .frame(height: 44)
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
