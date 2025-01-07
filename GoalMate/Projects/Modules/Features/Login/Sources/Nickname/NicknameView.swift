//
//  NicknameView.swift
//  Login
//
//  Created by Importants on 1/7/25.
//

import Common
import ComposableArchitecture
import SwiftUI

enum FocusableField: Hashable {
    case nickname
}

public struct NicknameView: View {
    @State public var store: StoreOf<NicknameFeature>
    @FocusState private var focusedField: FocusableField?

    public init(store: StoreOf<NicknameFeature>) {
        self.store = store
    }

    public var body: some View {
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
                LoginProcessView(processType: .nickname)
                Spacer()
                    .frame(height: 120)
                Text("앞으로 어떻게 불러드릴까요?")
                    .pretendard(.semiBold, size: 18, color: .black)
                Spacer()
                    .frame(height: 44)
                NickNameTextField(
                    nickname: $store.nickname,
                    state: $store.textFieldState,
                    focusedField: $focusedField
                )
                Spacer()
                RoundedButton(
                    buttonType: FilledStyle(backgroundColor: Colors.primary),
                    height: 54,
                    isDisabled: $store.isSubmitButtonDisabled
                ) {
                    store.send(.submitButtonTapped)
                } label: {
                    Text("닉네임 입력하기")
                        .pretendard(
                            .semiBold,
                            size: 16,
                            color: store.isSubmitButtonDisabled ? .white : .black
                        )
                }
                .ignoresSafeArea(.keyboard)  // 전체 키보드 영역 무시
            }
            .background {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { focusedField = nil }
            }
            .setMargin()
            .loading(isLoading: $store.isLoading)
        }
    }
}

fileprivate struct NickNameTextField: View {
    @Binding var nickname: String
    @Binding var state: NicknameFeature.TextFieldState
    var focusedField: FocusState<FocusableField?>.Binding

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22)
                .stroke(lineWidth: 1)
                .foregroundStyle(state == .valid ? Colors.gray400 : Colors.error)
            TextField(
                "",
                text: $nickname,
                prompt: Text("2~5글자 닉네임을 입력해주세요 :)")
                    .pretendardStyle(.regular, size: 16, color: Colors.gray400)
            )
            .labelsHidden()
            .focused(focusedField, equals: .nickname)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .frame(height: 44)
        HStack {
            if state == .valid {
                EmptyView()
            } else {
                HStack {
                    Text(state == .invalid ? "최소 2글자, 최대 5글자로 작성해 주세요." : "이미 있는 닉네임이에요 :(")
                        .pretendard(.regular, size: 14, color: Colors.error)
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    NicknameView(
        store: Store(
            initialState: NicknameFeature.State.init(),
            reducer: {
                NicknameFeature()
            }
        )
    )
}
