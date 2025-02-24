//
//  ProfileView.swift
//  FeatureProfile
//
//  Created by 이재훈 on 1/22/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI
import Utils

public struct ProfileView: View {
    @Perception.Bindable var store: StoreOf<ProfileFeature>
    public init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                VStack(spacing: 0) {
                    NavigationBar(
                        leftContent: {
                            Text("마이페이지")
                                .pretendardStyle(.semiBold, size: 20, color: Colors.grey900)
                        }
                    )
                    .frame(height: 64)
                    ScrollView {
                        Spacer()
                            .frame(height: 16)
                        VStack(spacing: 44) {
                            VStack(alignment: .leading, spacing: 8) {
                                if store.isLogin {
                                    Button {
                                        store.send(.view(.nicknameEditButtonTapped))
                                    } label: {
                                        HStack(spacing: 10) {
                                            Text("\(store.profile?.name ?? "")님")
                                                .pretendardStyle(
                                                    .semiBold,
                                                    size: 16,
                                                    color: Colors.grey900
                                                )
                                            Images.pencil
                                                .resized(length: 14)
                                                .background {
                                                    Circle()
                                                        .fill(Colors.primary100)
                                                        .frame(width: 24, height: 24)
                                                        .clipShape(.circle)
                                                }
                                        }
                                    }
                                    Text("안녕하세요!\n골메이트에 오신 것을 환영해요")
                                        .pretendardStyle(.regular, size: 14, color: Colors.grey900)
                                } else {
                                    Button {
                                        store.send(.view(.loginButtonTapped))
                                    } label: {
                                        HStack(spacing: 10) {
                                            Text("로그인 회원가입")
                                                .pretendardStyle(
                                                    .semiBold,
                                                    size: 16,
                                                    color: Colors.grey900
                                                )
                                            Image(systemName: "chevron.right")
                                                .resized(length: 10)
                                                .foregroundStyle(Colors.grey600)
                                        }
                                    }
                                    Text("회원가입하고 무료 목표 참여권 받으세요.")
                                        .pretendardStyle(.regular, size: 14, color: Colors.grey900)
                                        .padding(.bottom, 20)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical, 24)
                            .padding(.horizontal, 20)
                            .background(Colors.primary)
                            .clipShape(.rect(cornerRadius: 24))
                            .overlay {
                                if store.isLoading {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Colors.grey200)
                                }
                            }
                            if store.isLogin {
                                VStack(spacing: 8) {
                                    Text("목표 현황")
                                        .pretendard(
                                            .semiBold,
                                            size: 16,
                                            color: Colors.grey900
                                        )
                                        .overlay {
                                            if store.isLoading {
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(Colors.grey200)
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    HStack {
                                        Spacer()
                                        VStack(spacing: 4) {
                                            Text(
                                                "\(store.profile?.state.inProgressCount ?? 0)"
                                            )
                                            .pretendard(.semiBold, size: 20, color: Colors.grey900)
                                            Text("진행중")
                                                .pretendard(.regular, size: 14, color: Colors.grey800)
                                        }
                                        Spacer()
                                        Rectangle()
                                            .fill(Colors.primary200)
                                            .frame(width: 1)
                                        Spacer()
                                        VStack(spacing: 4) {
                                            Text(
                                                "\(store.profile?.state.completedCount ?? 0)"
                                            )
                                            .pretendard(.semiBold, size: 20, color: Colors.grey900)
                                            Text("진행완료")
                                                .pretendard(.regular, size: 14, color: Colors.grey800)
                                        }
                                        Spacer()
                                    }
                                    .frame(height: 50)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 25)
                                    .background(Colors.primary50)
                                    .clipShape(.rect(cornerRadius: 24))
                                    .overlay {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 24)
                                                .stroke(Colors.primary200, lineWidth: 1)
                                            if store.isLoading {
                                                RoundedRectangle(cornerRadius: 24)
                                                    .fill(Colors.grey200)
                                            }
                                        }
                                    }
                                    .onTapGesture {
                                        store.send(.view(.goalStatusButtonTapped))
                                    }
                                }
                            }
                            SeparatorView(height: 16, color: Colors.grey50)
                        }
                        VStack(spacing: 0) {
                            Spacer()
                                .frame(height: 20)
                            ListButton(
                                title: "자주 묻는 질문",
                                isLoading: false
                            ) {
                                store.send(
                                    .view(.qnaButtonTapped)
                                )
                            }
                            ListButton(
                                title: "개인 정보 처리 방침",
                                isLoading: false
                            ) {
                                store.send(
                                    .view(.privacyPolicyButtonTapped)
                                )
                            }
                            ListButton(
                                title: "이용약관",
                                isLoading: false
                            ) {
                                store.send(
                                    .view(.termsOfServiceButtonTapped)
                                )
                            }
                            if store.isLogin {
                                ListButton(
                                    title: "로그아웃",
                                    isLoading: store.isLoading
                                ) {
                                    store.send(
                                        .view(.logoutButtonTapped)
                                    )
                                }
                                ListButton(
                                    title: "탈퇴하기",
                                    isLoading: store.isLoading
                                ) {
                                    store.send(
                                        .view(.withdrawalButtonTapped)
                                    )
                                }
                            }
                        }
                    }
                    .loadingFailure(didFailToLoad: store.didFailToLoad) {
                        store.send(.view(.retryButtonTapped))
                    }
                }
                .padding(.horizontal, 20)
                .animation(
                    .easeInOut(duration: 0.3),
                    value: store.isLoading
                )
                CustomPopup(
                    isPresented: $store.isShowPopup.sending(\.dismissPopup),
                    leftButtonTitle: "아니요...",
                    rightButtonTitle: "네!",
                    leftAction: nil,
                    rightAction: {
                        store.send(.view(.logoutConfirmButtonTapped))
                    }
                ) {
                    VStack {
                        Images.warning
                            .resized(length: 24)
                        Spacer()
                            .frame(height: 10)
                        Text("화면 캡처 금지")
                            .pretendardStyle(
                                .semiBold,
                                size: 18,
                                color: Colors.grey800
                            )
                        Spacer()
                            .frame(height: 10)
                        Text("로그아웃 하시겠습니까?")
                            .multilineTextAlignment(.center)
                            .pretendard(
                                .semiBold,
                                size: 16,
                                color: Colors.grey600
                            )
                    }
                }
                .ignoresSafeArea()
            }

        }
        .task {
            store.send(.viewCycling(.onAppear))
        }
    }
}

fileprivate struct ListButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void
    init(
        title: String,
        isLoading: Bool,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        WithPerceptionTracking {
            Button {
                action()
            } label: {
                Text(title)
                    .pretendardStyle(.regular, size: 16, color: Colors.grey900)
                    .overlay {
                        if isLoading {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Colors.grey200)
                        }
                    }
                    .frame(height: 46)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    ProfileView(
        store: .init(
            initialState: .init()
        ) {
            withDependencies {
                $0.openURL = { .init { _ in true } }()
            } operation: {
                ProfileFeature()
            }
        }
    )
}
