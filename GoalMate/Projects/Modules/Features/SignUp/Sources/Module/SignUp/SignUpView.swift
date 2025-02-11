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
    enum FocusableField: Hashable {
        case nickname
    }
    @Perception.Bindable var store: StoreOf<SignUpFeature>
    @FocusState private var focusedField: FocusableField?
    @State private var keyboardHeight: CGFloat = 0

    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 86)
                SignUpProcessView(processType: $store.pageType)
                if store.pageType == .signUp {
                    authView
                        .opacity(store.pageType == .signUp ? 1 : 0)
                } else if store.pageType == .nickname {
                    nicknameView
                        .opacity(store.pageType == .nickname ? 1 : 0)
                } else {
                    signUpSuccessView
                        .opacity(store.pageType == .complete ? 1 : 0)
                }
            }
            .setMargin()
            .loading(isLoading: $store.isLoading)
            .onAppear {
                store.send(.viewCycling(.onAppear))
            }
            .transition(.opacity)
            .animation(.easeInOut, value: store.pageType)
            .toast(state: $store.toastState, position: .top)
        }
    }

    @ViewBuilder
    var authView: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 82)
                ZStack(alignment: .top) {
                    Images.loginBanner
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    VStack {
                        Spacer()
                            .frame(height: 16)
                        Text("당신의 멘토와 함께\n목표 달성을 시작해보세요!")
                            .pretendardStyle(.semiBold, size: 20)
                            .multilineTextAlignment(.center)
                    }
                }
                Spacer()
                VStack(spacing: 12) {
                    RoundedButton(
                        buttonType: FilledStyle(backgroundColor: Colors.kakaoBg),
                        height: 54
                    ) {
                        store.send(.auth(.signUpButtonTapped(.kakao)))
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
                        store.send(.auth(.signUpButtonTapped(.apple)))
                    } label: {
                        HStack(spacing: 5) {
                            Text("")
                            Text("Apple로 시작하기")
                        }
                        .pretendard(.semiBold, size: 16, color: .white)
                    }
                }
            }
        }

    }

    @ViewBuilder
    var nicknameView: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 120)
                Text("앞으로 어떻게 불러드릴까요?")
                    .pretendard(.semiBold, size: 18, color: .black)
                Spacer()
                    .frame(height: 44)
                textField
                Spacer()
                if store.keyboardHeight != 0 {
                    RoundedButton(
                        buttonType: FilledStyle(backgroundColor: Colors.primary),
                        height: 54,
                        isDisabled: store.nicknameFormState.isSubmitEnabled == false
                    ) {
                        store.send(.nickname(.submitButtonTapped))
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
                    .ignoresSafeArea(.keyboard)
                }
            }
            .onAppear {
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
                            text: .init(get: { store.nicknameFormState.inputText },
                                      set: {
                                          store.send(.nickname(.nicknameTextInputted($0)))
                                      }),
                            prompt: Text("2~5글자 닉네임을 입력해주세요.")
                                .foregroundColor(Colors.grey400)
                        )
                        .pretendard(.regular, size: 16, color: error ?
                                    Colors.error :
                                       (store.nicknameFormState.validationState == .valid ?
                                         Colors.focused :
                                            Colors.grey900
                                        ))
//                        .font(.system(size: 16, weight: .regular))
                        .labelsHidden()
                        .focused($focusedField, equals: .nickname)
                        Button {
                            store.send(.nickname(.duplicateCheckButtonTapped))
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

    @ViewBuilder
    var signUpSuccessView: some View {
        WithPerceptionTracking {
            VStack {
                Spacer()
                    .frame(height: 82)
                ZStack(alignment: .top) {
                    Images.loginSuccessBanner
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    VStack {
                        Spacer()
                            .frame(height: 40)
                        Text("환영해요 \(store.nickname)님,\n이제 첫 목표를 시작해보세요!")
                            .multilineTextAlignment(.center)
                            .pretendard(.semiBold, size: 18, color: Colors.grey900)
                    }
                }
                Spacer()
                RoundedButton(
                    buttonType: FilledStyle(backgroundColor: Colors.primary),
                    height: 54
                ) {
                    store.send(.signUpSuccess(.finishButtonTapped))
                } label: {
                    Text("골메이트 시작하기")
                        .pretendard(
                            .semiBold,
                            size: 16,
                            color: .black
                        )
                }
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    SignUpView(
        store: Store(
            initialState: SignUpFeature.State.init(),
            reducer: {
                withDependencies {
                    $0.authClient = .previewValue
                    $0.keyboardClient = .previewValue
                } operation: {
                    SignUpFeature()
                }
            }
        )
    )
}
