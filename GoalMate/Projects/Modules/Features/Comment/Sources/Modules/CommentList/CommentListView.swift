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
            VStack {
                NavigationBar(
                    leftContent: {
                        Text("코멘트")
                            .pretendardStyle(.semiBold, size: 20, color: Colors.grey900)
                    }
                )
                .frame(height: 64)
                ZStack {
                    ScrollView {
                        LazyVStack(spacing: 26) {
                            ForEach(store.commentRoomList, id: \.id) { content in
                                Button {
                                    store.send(
                                        .view(.chatRoomButtonTapped(
                                            content.id,
                                            content.menteeGoalTitle,
                                            content.startDate
                                        )))
                                } label: {
                                    HStack(spacing: 0) {
                                        if let urlString = content.mentorProfileImage,
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
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                case .failure:
                                                    Images.placeholder
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                @unknown default:
                                                    Rectangle()
                                                        .fill(.black)
                                                }
                                            }
                                            .frame(width: 70, height: 70)
                                            .clipShape(.circle)
                                        } else {
                                            Circle()
                                                .fill(Colors.grey100)
                                                .frame(width: 70, height: 70)
                                        }
                                        Spacer()
                                            .frame(width: 12)
                                        VStack(alignment: .leading) {
                                            let isExpired = getExpireStatus(
                                                fromDate: content.endDate ?? ""
                                            )
                                            HStack {
                                                Text(content.mentorName ?? "")
                                                    .pretendardStyle(
                                                        .medium,
                                                        size: 18,
                                                        color: Colors.grey900
                                                    )
                                                Text(isExpired ? "진행완료" : "진행중")
                                                    .pretendardStyle(
                                                        .medium,
                                                        size: 13,
                                                        color: isExpired ? Colors.grey500 : Colors.grey900
                                                    )
                                                Text(isExpired ?
                                                        "done" :
                                                        "D\(calculateDday(fromDate: content.endDate ?? ""))")
                                                    .pretendardStyle(
                                                        .semiBold,
                                                        size: 12,
                                                        color: isExpired ? .white : Colors.grey800
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
                                            Text(content.menteeGoalTitle?.splitCharacters() ?? "")
                                                .pretendardStyle(
                                                    .regular,
                                                    size: 14,
                                                    color: Colors.grey800
                                                )
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        Spacer()
                                            .frame(width: 12)
                                        if let newCommentsCount = content.newCommentsCount,
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
                                        if store.isLoading == false &&
                                            store.totalCount > 10 &&
                                            store.commentRoomList[
                                                store.totalCount-10].id == content.id {
                                            store.send(.view(.onLoadMore))
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    if store.isLoading == false &&
                        (store.isLogin == false || store.commentRoomList.isEmpty) {
                        emptyCommentView
                    }
                }

            }
            .padding(.horizontal, 20)
            .task {
                store.send(.viewCycling(.onAppear))
            }
        }
    }

    @ViewBuilder
    var skeletonView: some View {
        VStack {
            Spacer()
                .frame(height: 16)
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(width: 100, height: 20)
                Spacer()
            }
            Spacer()
                .frame(height: 20)
            RoundedRectangle(cornerRadius: 8)
                .fill(Colors.grey200)
                .frame(height: 118)
            Spacer()
                .frame(height: 56)
            Spacer()
                .frame(height: 20)
            HStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(width: 100, height: 20)
                Spacer()
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(width: 100, height: 30)
            }
            RoundedRectangle(cornerRadius: 8)
                .fill(Colors.grey200)
                .frame(height: 150)
            Spacer()
                .frame(height: 20)
            RoundedRectangle(cornerRadius: 8)
                .fill(Colors.grey200)
                .frame(height: 118)
            Spacer()
        }
        .padding(.horizontal, 20)
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

    func calculateDday(fromDate: String?) -> Int {
        guard let fromDate else { return 0 }
        let date = fromDate.toDate(format: "yyyy-MM-dd")
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let startDate = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: currentDate, to: startDate)
        return -(components.day ?? 0)  // 부호를 반대로 변경
    }

    func getExpireStatus(fromDate: String?) -> Bool {
        guard let fromDate else { return false }
        let date = fromDate.toDate(format: "yyyy-MM-dd")
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let endDate = calendar.startOfDay(for: date)
        return currentDate > endDate
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
