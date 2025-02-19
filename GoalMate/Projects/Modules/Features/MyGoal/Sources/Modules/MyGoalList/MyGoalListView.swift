//
//  MyGoalListView.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import ComposableArchitecture
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
                            .pretendardStyle(.semiBold, size: 20, color: Colors.grey900)
                    }
                )
                .frame(height: 64)
                .padding(.horizontal, 20)
                ZStack {
                    myGoalListView
                    if store.isLoading == false &&
                       (store.isLogin == false || store.myGoalList.isEmpty) {
                        emptyMyGoalView
                    }
                }
                .loadingFailure(didFailToLoad: store.didFailToLoad) {
                    store.send(.view(.retryButtonTapped))
                }
            }
            .task {
                store.send(.viewCycling(.onAppear))
            }
        }
    }
    @ViewBuilder
    var myGoalListView: some View {
        WithPerceptionTracking {
            ScrollView {
                LazyVStack {
                    ForEach(store.myGoalList, id: \.id) { content in
                        VStack(spacing: 0) {
                            MyGoalContentItem(content: content) { type in
                                store.send(.view(.buttonTapped(type)))
                            }
                            .task {
                                if store.isLoading == false &&
                                    store.totalCount > 10 &&
                                    store.myGoalList[store.totalCount-10].id == content.id {
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
                if store.isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(1.7, anchor: .center)
                }
            }
            .scrollIndicators(.hidden)
//            VStack {
//                List {
//                    ForEach(store.myGoalList, id: \.id) { content in
//                        VStack(spacing: 0) {
//                            MyGoalContentItem(content: content) { type in
//                                store.send(.view(.buttonTapped(type)))
//                            }
//                            .task {
//                                if store.isLoading == false &&
//                                    store.myGoalList[store.totalCount-10].id == content.id {
//                                    store.send(.view(.onLoadMore))
//                                }
//                            }
//                            Rectangle()
//                                .fill(Colors.grey50)
//                                .frame(height: 16)
//                        }
//                    }
//                    .listRowSeparator(.hidden)
//                    .listRowInsets(EdgeInsets())
//                    .listRowBackground(Color.clear)
//                    if store.isLoading {
//                        ProgressView()
//                            .progressViewStyle(.circular)
//                            .scaleEffect(1.7, anchor: .center)
//                    }
//                }
//                .listStyle(.plain)
//                .background(Color.clear)
//                .scrollContentBackground(.hidden)
//                .scrollIndicators(.hidden)
//            }
        }
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
    let content: MyGoalContent
    let buttonTapped: (MyGoalListFeature.ButtonType) -> Void
    init(
        content: MyGoalContent,
        buttonTapped: @escaping (MyGoalListFeature.ButtonType) -> Void
    ) {
        self.content = content
        self.buttonTapped = buttonTapped
    }
    var body: some View {
        WithPerceptionTracking {
            let isExpired = content.goalStatus == .completed
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
                    Text(isExpired ? "done" : "D+\(calculateDplus(fromDate: content.startDate))")
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
                    CachedImageView(url: content.mainImageURL)
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
                    VStack(alignment: .leading) {
                        Text(content.title)
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
                            Text("\(content.startDate) 부터\n\(content.endDate) 까지")
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
                        progress: .constant(content.progress),
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
                                buttonTapped(.restart(content.id))
                            },
                            label: {
                                Text("다시 시작가기")
                                    .pretendardStyle(.regular, size: 16)
                            }
                        )
                        RoundedButton(
                            buttonType: FilledStyle(backgroundColor: Colors.primary),
                            height: 44,
                            buttonTapped: {
                                buttonTapped(.showDetail(content.id))
                            },
                            label: {
                                Text("보러가기")
                                    .pretendardStyle(.regular, size: 16)
                            }
                        )
                    }
                } else {
                    RoundedButton(
                        buttonType: FilledStyle(backgroundColor: Colors.primary),
                        height: 44,
                        buttonTapped: {
                            buttonTapped(.showDetail(content.id))
                        },
                        label: {
                            Text("진행하기")
                                .pretendardStyle(.regular, size: 16)
                        }
                    )
                }
                Spacer()
                    .frame(height: 30)
            }
            .padding(20)
        }
    }

    func calculateDplus(fromDate: String) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        let date = dateFormatter.date(from: fromDate)
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let startDate = calendar.startOfDay(for: date ?? Date())
        let components = calendar.dateComponents([.day], from: startDate, to: currentDate)
        return components.day ?? 0
    }
}

@available(iOS 17.0, *)
#Preview {
    
    MyGoalListView(
        store: .init(
            initialState: .init(
                myGoalList: MyGoalContent.dummies
            )
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
