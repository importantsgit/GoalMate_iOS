//
//  NicknameView.swift
//  SignUp
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI

enum FocusableField: Hashable {
    case nickname
}

public struct NicknameView: View {
    @State public var store: StoreOf<NicknameFeature>
    @FocusState private var focusedField: FocusableField?
    @State private var keyboardHeight: CGFloat = 0
    
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
                SignUpProcessView(processType: .nickname)
                Spacer()
                    .frame(height: 120)
                Text("앞으로 어떻게 불러드릴까요?")
                    .pretendard(.semiBold, size: 18, color: .black)
                Spacer()
                    .frame(height: 44)
                textField
                Spacer()
                if keyboardHeight != 0 {
                    RoundedButton(
                        buttonType: FilledStyle(backgroundColor: Colors.primary),
                        height: 54,
                        isDisabled: $store.isSubmitButtonDisabled
                    ) {
                        store.send(.submitButtonTapped)
                    } label: {
                        Text("닉네임 입력완료")
                            .pretendard(
                                .semiBold,
                                size: 16,
                                color: store.isSubmitButtonDisabled ? .white : .black
                            )
                    }
                    .ignoresSafeArea(.keyboard)  // 전체 키보드 영역 무시
                }
            }
            .background {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { focusedField = nil }
            }
            .setMargin()
            .loading(isLoading: $store.isLoading)
            .onAppear {
                focusedField = .nickname
            }
            .onReceive(
                NotificationCenter
                    .default
                    .publisher(
                        for: UIResponder.keyboardWillShowNotification
                    )
            ) { notification in
                guard let userInfo = notification.userInfo,
                      let keyboardRect = userInfo[
                        UIResponder.keyboardFrameEndUserInfoKey
                      ] as? CGRect
                else { return }
                Task {
                    print("keyboardHeight: \(keyboardRect)")
                    await MainActor.run {
                        self.keyboardHeight = keyboardRect.height
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    var textField: some View {
        let state = store.textFieldState
        let error = store.textFieldState == .duplicate ||
                    state == .invalid
        VStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(
                        error ?
                        Colors.error :
                            (state == .valid ?
                             Colors.focused :
                                Colors.grey400
                            )
                    )
                HStack {
                    TextField(
                        "",
                        text: $store.nickname,
                        prompt: Text("2~5글자 닉네임을 입력해주세요.")
                            .pretendardStyle(.regular, size: 16, color: Colors.grey400)
                    )
                    .pretendard(
                        .regular,
                        size: 16,
                        color: error ?
                        Colors.error :
                            (store.textFieldState == .valid ?
                             Colors.focused :
                                Colors.grey900
                            )
                    )
                    .labelsHidden()
                    .focused($focusedField, equals: .nickname)
                    Button {
                        store.send(.duplicateCheckButtonTapped)
                    } label: {
                        Text("중복 확인")
                            .pretendard(
                                .medium,
                                size: 12,
                                color: store.isDuplicateCheckButtonDisabled ?
                                    .white :
                                        .black
                            )
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(
                                store.isDuplicateCheckButtonDisabled ?
                                Colors.grey300 :
                                    Colors.primary
                            )
                            .clipShape(.capsule)
                    }
                    .disabled(store.isDuplicateCheckButtonDisabled)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }
            .frame(height: 44)
            if state != .idle {
                HStack {
                    HStack {
                        Text(state.message)
                            .pretendard(
                                .regular,
                                size: 14,
                                color: error ?
                                Colors.error :
                                    Colors.focused
                            )
                        Spacer()
                    }
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
