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
    @State var store: StoreOf<SignUpFeature>
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
                store.send(.onAppear)
            }
            .transition(.opacity)
            .animation(.easeInOut, value: store.pageType)
        }
    }

    @ViewBuilder
    var authView: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
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
                            text: $store.input,
                            prompt: Text("2~5글자 닉네임을 입력해주세요.")
//                                n
                        )
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(error ?
                                         Colors.error :
                                             (store.textFieldState == .valid ?
                                              Colors.focused :
                                                 Colors.grey900
                                             ))
                        .labelsHidden()
                        .focused($focusedField, equals: .nickname)
                        .onChange(of: store.nickname) { text in
                            print("text: \(text)")
                            let isValidNickname = (2...5 ~= text.count)
                            print("isValid??: \(isValidNickname)")
                            store.textFieldState = isValidNickname ? .idle : .invalid
                            store.isSubmitButtonDisabled = true
                            store.isDuplicateCheckButtonDisabled = isValidNickname == false
                        }
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

    @ViewBuilder
    var signUpSuccessView: some View {
        WithPerceptionTracking {
            VStack {
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
                            Text("축하해요\n\(store.nickname)님,\n바로 첫 목표를 시작해보세요!")
                                .lineLimit(nil)
                                .multilineTextAlignment(.center)
                                .pretendard(.semiBold, size: 18, color: Colors.grey900)
                            Spacer()
                        }
                    }
                Spacer()
                RoundedButton(
                    buttonType: FilledStyle(backgroundColor: Colors.primary),
                    height: 54
                ) {
                    store.send(.finishButtonTapped)
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
