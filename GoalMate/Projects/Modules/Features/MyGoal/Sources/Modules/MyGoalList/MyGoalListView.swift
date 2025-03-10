//
//  MyGoalListView.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import ComposableArchitecture
import Data
import FeatureCommon
import SwiftUI
import Utils

public struct MyGoalListView: View {
    @State var store: StoreOf<MyGoalListFeature>
    public init(store: StoreOf<MyGoalListFeature>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                NavigationBar(
                    leftContent: {
                        Text("나의 목표")
                            .pretendardStyle(
                                .semiBold,
                                size: 20,
                                color: Colors.grey900)
                    }
                )
                .frame(height: 52)
                ZStack {
                    myGoalListView
                    if store.isLoading == false &&
                       (store.isLogin == false || store.myGoalList.isEmpty) {
                        emptyMyGoalView
                    }
                    if store.isLoading {
                        skeletonView
                            .transition(.opacity)
                    }
                }
                .loadingFailure(didFailToLoad: store.didFailToLoad) {
                    store.send(.view(.retryButtonTapped))
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
        var myGoalListView: some View {
            WithPerceptionTracking {
                ScrollView {
                    LazyVStack {
                        ForEach(store.myGoalList) { content in
                            VStack(spacing: 30) {
                                MyGoalContentItem(content: content) { type in
                                    store.send(.view(.buttonTapped(type)))
                                }
                                .id(content.id)
                                .task {
                                    let isNearEnd = store.myGoalList.count >= 3 &&
                                        content.id == store.myGoalList[
                                            store.myGoalList.count - 3].id
                                    if store.isScrollFetching == false &&
                                        isNearEnd {
                                        store.send(.view(.onLoadMore))
                                    }
                                }
                                if content.id != store.myGoalList.last?.id {
                                    Rectangle()
                                        .fill(Colors.grey50)
                                        .frame(height: 16)
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
                    store.send(.view(.refreshMyGoalList))
                }
                .scrollIndicators(.hidden)
            }
        }

    @ViewBuilder
    var skeletonView: some View {
        VStack {
            ForEach(0...1, id: \.self) { _ in
                Spacer()
                    .frame(height: 40)
                VStack(alignment: .leading, spacing: 0) {
                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.grey200)
                            .frame(width: 80, height: 20)
                        Spacer()
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        VStack {
                            HStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Colors.grey200)
                                    .frame(width: 120)
                                VStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Colors.grey200)
                                        .frame(width: 120, height: 20)
                                    Spacer()
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Colors.grey200)
                                        .frame(width: 150, height: 40)
                                }
                            }
                        }
                        .frame(height: 90)
                    }
                    Spacer()
                        .frame(height: 16)
                    HStack {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.grey200)
                            .frame(width: 80, height: 18)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.grey200)
                            .frame(height: 20)
                            .frame(maxWidth: .infinity)
                    }
                    Spacer()
                        .frame(height: 4)
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.grey200)
                            .frame(height: 20)
                            .frame(maxWidth: 40)
                    }
                    Spacer()
                        .frame(height: 16)
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Colors.grey200)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .background(.white)
    }

    @ViewBuilder
    var emptyMyGoalView: some View {
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
}

fileprivate struct MyGoalContentItem: View {
    let content: MenteeGoal
    let buttonTapped: (MyGoalListFeature.ButtonType) -> Void
    init(
        content: MenteeGoal,
        buttonTapped: @escaping (MyGoalListFeature.ButtonType) -> Void
    ) {
        self.content = content
        self.buttonTapped = buttonTapped
    }
    var body: some View {
        WithPerceptionTracking {
            let isExpired = content.menteeGoalStatus == .completed
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 24)
                HStack(spacing: 4) {
                    Text(isExpired ? "진행완료" : "진행중")
                        .pretendardStyle(
                            .medium,
                            size: 13,
                            color: isExpired ? Colors.grey500 : Colors.grey900
                        )
                    let dDay = Date().toString()
                        .calculateDday(endDate: content.endDate ?? "")
                    Text(isExpired ?
                            "done" :
                            dDay)
                        .pretendardStyle(
                            .semiBold,
                            size: 12,
                            color: isExpired ? .white : Colors.grey800
                        )
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(isExpired ? Colors.secondaryP : Colors.secondaryY)
                        .clipShape(.rect(cornerRadius: 4))
                    Spacer()
                }
                Spacer()
                    .frame(height: 14)
                HStack(spacing: 10) {
                    if  let mainImage = content.mainImage,
                        let imageUrl = URL(string: mainImage) {
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
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            case .failure:
                                Images.placeholder
                                    .resizable()
                            @unknown default:
                                Rectangle()
                                    .fill(.black)
                            }
                        }
                        .frame(width: 120, height: 90)
                        .overlay {
                            if isExpired {
                                ZStack {
                                    Colors.grey200.opacity(0.5)
                                    Images.goalCompleted
                                }
                            }
                        }
                        .clipShape(.rect(cornerRadius: 4))
                    } else {
                        Images.placeholder
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 120, height: 90)
                            .clipShape(.rect(cornerRadius: 4))
                    }

                    VStack(alignment: .leading) {
                        Text(content.title ?? "")
                            .pretendard(
                                .medium,
                                size: 16,
                                color: isExpired ? Colors.grey500 : Colors.grey900
                            )
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        HStack(alignment: .top, spacing: 10) {
                            if isExpired {
                                Images.calendarCompleted
                                    .resized(length: 16)
                            } else {
                                Images.calendarP
                                    .resized(length: 16)
                            }
                            let startDate = (content.startDate ?? "")
                                .convertDateString(toFormat: "yyyy년 MM월 dd일")
                            let endDate = (content.endDate ?? "")
                                .convertDateString(toFormat: "yyyy년 MM월 dd일")
                            Text("\(startDate ?? "") 부터\n\(endDate ?? "") 까지")
                                .pretendard(
                                    .medium,
                                    size: 11,
                                    color: isExpired ? Colors.grey500 : Colors.grey600
                                )
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Colors.grey50)
                        .clipShape(.rect(cornerRadius: 6))
                    }
                }
                Spacer()
                    .frame(height: 16)
                HStack(alignment: .top, spacing: 6) {
                    HStack(spacing: 0) {
                        Text("전체 진척율")
                            .pretendardStyle(.semiBold, size: 13, color: Colors.grey500)
                        if isExpired {
                            Images.flag
                                .resized(length: 16)
                        } else {
                            Images.progress
                                .resized(length: 16)
                        }
                    }
                    LinearProgressView(
                        progress:
                            Double(content.totalCompletedCount) /
                        Double(content.totalTodoCount),
                        progressColor: isExpired ? Colors.grey400 : Colors.primary,
                        backgroundColor: isExpired ? Colors.grey100 : Colors.primary50,
                        lineWidth: 14
                    )
                }
                Spacer()
                    .frame(height: 16)
                if isExpired {
                    HStack(spacing: 12) {
                        RoundedButton(
                            buttonType: BorderStyle(
                                borderConfig: .init(
                                    color: Colors.grey300,
                                    width: 2
                                ),
                                backgroundColor: .white
                            ),
                            height: 44,
                            buttonTapped: {
                                buttonTapped(.showGoalRestart(content.goalId))
                            },
                            label: {
                                Text("다시 시작하기")
                                    .pretendardStyle(.regular, size: 16)
                            }
                        )
                        RoundedButton(
                            buttonType: FilledStyle(backgroundColor: Colors.primary),
                            height: 44,
                            buttonTapped: {
                                buttonTapped(.showGoalCompletion(content.id))
                            },
                            label: {
                                Text("보러가기")
                                    .pretendardStyle(.regular, size: 16)
                            }
                        )
                    }
                } else {
                    let remainingCount: Int = content.todayRemainingCount
                    let hasRemainingTodo: Bool = remainingCount > 0
                    RoundedButton(
                        buttonType: FilledStyle(backgroundColor: Colors.primary),
                        height: 44,
                        buttonTapped: {
                            buttonTapped(.showGoalDetail(content.id))
                        },
                        label: {
                            Text(hasRemainingTodo ?
                                 "오늘 해야 할 일 \(remainingCount)개 완료하기" :
                                 "진행하기")
                                .pretendardStyle(.regular, size: 16)
                        }
                    )
                }
                Spacer()
                    .frame(height: 30)
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    MyGoalListView(
        store: .init(
            initialState: .init()
        ) {
            withDependencies {
                $0.authClient = .previewValue
                $0.menteeClient = .previewValue
            } operation: {
                MyGoalListFeature()
            }
        }
    )
}
