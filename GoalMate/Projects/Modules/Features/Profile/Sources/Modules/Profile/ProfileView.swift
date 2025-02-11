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
    @State var store: StoreOf<ProfileFeature>
    public init(store: StoreOf<ProfileFeature>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
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
                            Button {
                                // 네이밍 변경
                            } label: {
                                HStack(spacing: 10) {
                                    Text("김골메이트님")
                                        .pretendardStyle(.semiBold, size: 16, color: Colors.grey900)
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
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 24)
                        .padding(.horizontal, 20)
                        .background(Colors.primary)
                        .clipShape(.rect(cornerRadius: 24))
                        VStack(spacing: 8) {
                            Text("목표 현황")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .pretendard(.semiBold, size: 16, color: Colors.grey900)
                            HStack {
                                Spacer()
                                VStack(spacing: 4) {
                                    Text(
                                        "\(store?.profile?.state?.inProgressCount ?? 0)"
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
                                        "\(store?.profile?.state?.completedCount ?? 0)"
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
                                RoundedRectangle(cornerRadius: 24)
                                    .stroke(Colors.primary200, lineWidth: 1)
                            }
                        }
                        SeparatorView(height: 16, color: Colors.grey50)
                    }
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: 20)
                        ListButton(title: "자주 묻는 질문") {
                            store.send(
                                .view(.qnaButtonTapped)
                            )
                        }
                        ListButton(title: "개인 정보 처리 방침") {
                            store.send(
                                .view(.privacyPolicyButtonTapped)
                            )
                        }
                        ListButton(title: "이용약관") {
                            store.send(
                                .view(.termsOfServiceButtonTapped)
                            )
                        }
                        ListButton(title: "탈퇴하기") {
                            store.send(
                                .view(.withdrawalButtonTapped)
                            )
                        }
                    }
                }

            }
            .padding(.horizontal, 20)
        }
    }
}

fileprivate struct ListButton: View {
    let title: String
    let action: () -> Void

    init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .pretendardStyle(.regular, size: 16, color: Colors.grey900)
                .frame(height: 46)
                .frame(maxWidth: .infinity, alignment: .leading)
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

            ProfileFeature()
        }
    )
}
