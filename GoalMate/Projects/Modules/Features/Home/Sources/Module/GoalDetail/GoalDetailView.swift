//
//  GoalDetailView.swift
//  FeatureHome
//
//  Created by 이재훈 on 1/9/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI

struct GoalDetailView: View {
    @State var store: StoreOf<GoalDetailFeature>
    var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .bottom) {
                VStack {
                    NavigationBar(
                        leftContent: {
                            Button {
                                store.send(.backButtonTapped)
                            } label: {
                                VStack {
                                    Images.back
                                        .resized(length: 24)
                                }
                                .padding(.all, 12)
                            }
                        }
                    )
                    .padding(.horizontal, 16)
                    .background(Color.white)
                    ScrollView(.vertical) {
                        if store.images.isEmpty {
                            Colors.gray200
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(1, contentMode: .fit)
                        } else {
                            pageView
                        }
                        VStack(spacing: 8) {
                            Text("(멘토명)과 함께하는 (목표명) 목표 (멘토명)과 함께하는 (목표명) 목표")
                                .pretendardStyle(
                                    .semiBold,
                                    size: 18,
                                    color: Colors.gray900
                                )
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                            VStack(spacing: 4) {
                                HStack(spacing: 6) {
                                    Text("100%")
                                        .pretendardStyle(
                                            .semiBold,
                                            size: 14,
                                            color: Colors.error
                                        )
                                    Text("10,000원")
                                        .pretendardStyle(
                                            .semiBold,
                                            size: 13,
                                            color: Colors.gray500
                                        )
                                        .strikethrough(
                                            color: Colors.gray500
                                        )
                                }
                                .frame(
                                    maxWidth: .infinity,
                                    alignment: .leading
                                )
                                Text("0원")
                                    .pretendardStyle(
                                        .semiBold,
                                        size: 22
                                    )
                                    .frame(
                                        maxWidth: .infinity,
                                        alignment: .leading
                                    )
                            }
                        }
                        Spacer()
                    }
                    .setMargin()
                }
                bottomButtonView
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}

private extension GoalDetailView {
    var pageView: some View {
        TabView(selection: $store.currentPage) {
            ForEach(Array(store.images.enumerated()), id: \.offset) { index, image in
                image
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .tag(index)
                    .background(Colors.gray200)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .overlay(alignment: .bottom) {
            // 커스텀 인디케이터
            let count = store.images.count
            if count > 1 {
                HStack(spacing: 8) {
                    ForEach(Array(0..<count), id: \.self) { index in
                        Circle()
                            .fill(
                                store.currentPage == index ?
                                Color(hex: "A1A0A0") :
                                    Color(hex: "F5F5F5")
                            )
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }

    var bottomButtonView: some View {
        VStack(spacing: 10) {
            HStack {
                RoundedButton(
                    buttonType: BorderStyle(
                        borderConfig: .init(
                            color: Color.purple,
                            width: 2
                        ),
                        backgroundColor: .white
                    ),
                    height: 32,
                    horizontalPadding: 12,
                    verticalPadding: 10,
                    buttonTapped: {
                        // TODO: 액션 추가
                    },
                    label: {
                        HStack(spacing: 4) {
                            Images.bell
                                .resized(length: 16)
                            Text("무료참여 ??자리 남았어요")
                                .pretendardStyle(
                                    .regular,
                                    size: 12,
                                    color: Colors.secondaryP
                                )
                        }
                    }
                )
            }
            RoundedButton(
                buttonType: FilledStyle(backgroundColor: Colors.primary),
                buttonTapped: {
                    // TODO: 액션 추가
                },
                label: {
                    Text("목표 시작하기")
                        .pretendardStyle(.semiBold, size: 16)
                }
            )
            .padding(.horizontal, 20)
            Spacer()
                .frame(height: 16)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.clear, .white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    var TitleView: some View {
        
    }
}

@available(iOS 17.0, *)
#Preview {
    GoalDetailView(
        store: Store(
            initialState: GoalDetailFeature.State.init(
                contentId: "1",
                images: [Images.alarm]
            ),
            reducer: {
                GoalDetailFeature()
            }
        )
    )
}
