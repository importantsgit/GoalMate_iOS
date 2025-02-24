//
//  NicknameEditView.swift
//  FeatureProfile
//
//  Created by Importants on 2/17/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI
import TCACoordinators

struct NicknameEditView: View {
    enum FocusableField: Hashable {
        case nickname
    }
    @Perception.Bindable var store: StoreOf<NicknameEditFeature>
    @FocusState private var focusedField: FocusableField?
    @State private var keyboardHeight: CGFloat = 0
    var body: some View {
        WithPerceptionTracking {
            nicknameView
                .padding(.horizontal, 20)
                .toast(state: $store.toastState)
        }
    }

    @ViewBuilder
    var nicknameView: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 36)
                    .overlay {
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Colors.grey300)
                            .frame(width: 32, height: 4)
                    }
                Spacer()
                    .frame(height: 16)
                textField
                Spacer()
                    .frame(height: 80)
                RoundedButton(
                    buttonType: FilledStyle(backgroundColor: Colors.primary),
                    height: 54,
                    isDisabled: store.nicknameFormState.isSubmitEnabled == false
                ) {
                    store.send(.view(.submitButtonTapped))
                } label: {
                    Text("닉네임 입력완료")
                        .pretendard(
                            .semiBold,
                            size: 16,
                            color: store
                                .nicknameFormState
                                .isSubmitEnabled ? .black : .white
                        )
                }
                Spacer()
            }
            .task {
                store.send(.viewCycling(.onAppear))
                focusedField = .nickname
            }
        }
    }

    @ViewBuilder
    var textField: some View {
        WithPerceptionTracking {
            let state = store.nicknameFormState.validationState
            let error = state == .duplicate ||
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
                            text: $store.inputText.sending(\.nicknameTextInputted),
                            prompt: Text("2~5글자 닉네임을 입력해주세요.")
                                .foregroundColor(Colors.grey400)
                        )
                        .pretendard(.regular, size: 16, color: error ?
                                    Colors.error :
                                       (store.nicknameFormState.validationState == .valid ?
                                         Colors.focused :
                                            Colors.grey900
                                        ))
                        .labelsHidden()
                        .focused($focusedField, equals: .nickname)
                        Button {
                            store.send(.view(.duplicateCheckButtonTapped))
                        } label: {
                            Text("중복 확인")
                                .pretendard(
                                    .medium,
                                    size: 12,
                                    color: store.nicknameFormState.isDuplicateCheckEnabled ?
                                            .black :
                                            .white
                                )
                                .padding(.vertical, 6)
                                .padding(.horizontal, 10)
                                .background(
                                    store.nicknameFormState.isDuplicateCheckEnabled ?
                                        Colors.primary : Colors.grey300
                                )
                                .clipShape(.capsule)
                        }
                        .disabled(store.nicknameFormState.isDuplicateCheckEnabled == false)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                }
                .frame(height: 44)
                if state != .idle {
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
                    .frame(height: 20)
                } else {
                    Spacer()
                        .frame(height: 20)
                }
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    VStack {
        Text("Hello")
    }
    .sheet(isPresented: .constant(true)) {
        NicknameEditView(
            store: Store(
                initialState: NicknameEditFeature.State.init(nickname: "hello"),
                reducer: {
                    withDependencies {
                        $0.authClient = .previewValue
                        $0.environmentClient = .previewValue
                    } operation: {
                        NicknameEditFeature()
                    }
                }
            )
        )
        .customSheet(
            heights: [370],
            radius: 30,
            corners: [.topLeft, .topRight]
        )
    }
}
