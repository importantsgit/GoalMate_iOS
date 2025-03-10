//
//  CommentListView.swift
//  FeatureComment
//
//  Created by Importants on 2/23/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI
import Utils

public struct CommentListView: View {
    @Perception.Bindable var store: StoreOf<CommentListFeature>
    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                NavigationBar(
                    leftContent: {
                        Text("코멘트")
                            .pretendardStyle(.semiBold, size: 20, color: Colors.grey900)
                    }
                )
                .frame(height: 52)
                ZStack {
                    commentListView
                    if store.isLoading == false &&
                        (store.isLogin == false || store.commentRoomList.isEmpty) {
                        emptyCommentView
                    }
                    if store.isLoading {
                        skeletonView
                            .opacity(0.7)
                            .transition(.opacity)
                    }
                }
            }
            .padding(.horizontal, 20)
            .animation(
                .easeInOut(duration: 0.2),
                value: store.isLoading)
            .task {
                store.send(.viewCycling(.onAppear))
            }
            .onDisappear {
                store.send(.viewCycling(.onDisappear))
            }
        }
    }

    @ViewBuilder
    var skeletonView: some View {
        VStack {
            ForEach(0..<3) { _ in
                HStack(spacing: 0) {
                    Circle()
                        .fill(Colors.grey400)
                        .frame(width: 64, height: 64)
                    Spacer()
                        .frame(width: 12)
                    VStack(alignment: .leading, spacing: 2) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.grey400)
                            .frame(width: 120, height: 22)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.grey400)
                            .frame(height: 16)
                    }
                    Spacer()
                        .frame(width: 12)
                    Spacer()
                        .frame(width: 12, height: 12)
                        .padding(6)
                }
            }
            Spacer()
        }
        .background(.white)
    }

    @ViewBuilder
    var emptyCommentView: some View {
        WithPerceptionTracking {
            ZStack {
                Color.white
                VStack(spacing: 24) {
                    Text("현재 진행 중인 목표가 없어요.\n참여할 목표를 보러 갈까요?")
                        .pretendardStyle(
                            .regular,
                            size: 16,
                            color: Colors.grey900
                        )
                        .multilineTextAlignment(.center)
                    Button {
                        store.send(.view(.showMoreButtonTapped))
                    } label: {
                        Text("보러가기")
                            .pretendard(.regular, size: 16)
                            .padding(.horizontal, 50)
                            .padding(.vertical, 12)
                            .background(Colors.primary)
                            .clipShape(.capsule)
                    }
                }
            }
        }
    }

    @ViewBuilder
    var commentListView: some View {
        ScrollView {
            LazyVStack(spacing: 26) {
                ForEach(store.commentRoomList, id: \.id) { content in
                    let isExpired = content.isExpired
                    Button {
                        store.send(
                            .view(.chatRoomButtonTapped(
                                content.roomInfo.id,
                                content.roomInfo.menteeGoalTitle,
                                content.roomInfo.endDate
                            )))
                    } label: {
                        HStack(spacing: 0) {
                            if let urlString = content
                                .roomInfo.mentorProfileImage,
                                let imageUrl = URL(string: urlString) {
                                AsyncImage(
                                    url: imageUrl
                                ) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .progressViewStyle(.circular)
                                    case .success(let image):
                                        image
                                            .resizable()
                                    case .failure:
                                        Images.placeholder
                                            .resizable()
                                    @unknown default:
                                        Rectangle()
                                            .fill(.black)
                                    }
                                }
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 64, height: 64)
                                .clipShape(.circle)
                            } else {
                                Circle()
                                    .fill(Colors.grey100)
                                    .frame(width: 64, height: 64)
                            }
                            Spacer()
                                .frame(width: 12)
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 8) {
                                    Text(content.roomInfo.mentorName ?? "")
                                        .pretendardStyle(
                                            .medium,
                                            size: 18,
                                            color: Colors.grey900
                                        )
                                    HStack(spacing: 4) {
                                        Text(isExpired ? "진행완료" : "진행중")
                                            .pretendardStyle(
                                                .medium,
                                                size: 13,
                                                color: isExpired ?
                                                    Colors.grey500 :
                                                    Colors.grey900
                                            )
                                        Text(isExpired ?
                                                "done" :
                                                content.dDay)
                                            .pretendardStyle(
                                                .semiBold,
                                                size: 12,
                                                color: isExpired ?
                                                        .white :
                                                    Colors.grey800
                                            )
                                            .padding(.horizontal, 4)
                                            .padding(.vertical, 2)
                                            .background(
                                                isExpired ?
                                                    Colors.secondaryP :
                                                    Colors.secondaryY
                                            )
                                            .clipShape(.rect(cornerRadius: 4))
                                    }
                                }
                                Text(content.roomInfo
                                    .menteeGoalTitle?.splitCharacters() ?? "")
                                    .pretendardStyle(
                                        .regular,
                                        size: 14,
                                        color: Colors.grey800
                                    )
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                                .frame(width: 12)
                            if let newCommentsCount = content.roomInfo.newCommentsCount,
                               newCommentsCount > 0 {
                                Circle()
                                    .fill(Colors.error)
                                    .frame(width: 12, height: 12)
                                    .padding(6)
                            } else {
                                Spacer()
                                    .frame(width: 12, height: 12)
                                    .padding(6)
                            }

                        }
                        .task {
                            let isNearEnd = store.commentRoomList.count >= 3 &&
                                content.id == store.commentRoomList[
                                    store.commentRoomList.count-3].id
                            if store.isScrollFetching == false &&
                                isNearEnd {
                                store.send(.view(.onLoadMore))
                            }
                        }
                    }
                }
            }
            if store.isScrollFetching {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.7, anchor: .center)
            }
            Spacer()
                .frame(height: 105)
        }
        .refreshable {
            store.send(.view(.refreshCommentList))
        }
        .scrollIndicators(.hidden)
    }
}

@available(iOS 17.0, *)
#Preview {
    CommentListView(
        store: Store(
            initialState: CommentListFeature.State.init(),
            reducer: {
                withDependencies {
                    $0.calendar = .current
                } operation: {
                    CommentListFeature()
                }
            }
        )
    )
}
