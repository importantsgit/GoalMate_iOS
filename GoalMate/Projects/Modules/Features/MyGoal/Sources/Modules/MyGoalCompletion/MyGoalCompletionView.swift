//
//  MyGoalCompletionView.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 2/21/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI

public struct MyGoalCompletionView: View {
    @Perception.Bindable var store: StoreOf<MyGoalCompletionFeature>
    public var body: some View {
        WithPerceptionTracking {
            VStack {
                NavigationBar(
                    leftContent: {
                        Button {
                            store.send(.view(.backButtonTapped))
                        } label: {
                            Images.back
                                .resized(length: 24)
                                .padding(.all, 12)
                        }
                    },
                    centerContent: {
                        Text("목표 완료")
                            .pretendardStyle(
                                .semiBold,
                                size: 20,
                                color: Color(hex: "212121")
                            )
                    }
                )
                .frame(height: 64)
                .padding(.leading, 4)
                Group {
                    ZStack(alignment: .bottom) {
                        ScrollView {
                            VStack(spacing: 0) {
                                goalDetailView
                                Spacer()
                                    .frame(height: 30)
                                commentView
                                Spacer()
                                    .frame(height: 16)
                                Button {
                                    store.send(.view(.mentorCommentButtonTapped))
                                } label: {
                                    HStack {
                                        Text("멘토 코멘트")
                                            .pretendardStyle(
                                                .semiBold,
                                                size: 16,
                                                color: Colors.grey900
                                            )
                                        Spacer()
                                        HStack(spacing: 8) {
                                            Text("자세히 보기")
                                                .pretendardStyle(
                                                    .medium,
                                                    size: 14,
                                                    color: Colors.grey500
                                                )
                                            Image(systemName: "chevron.right")
                                                .resized(length: 10)
                                                .foregroundStyle(Colors.grey500)
                                        }
                                    }
                                    .padding(.vertical, 24)
                                    .padding(.horizontal, 28)
                                    .background(Colors.grey100)
                                    .clipShape(.rect(cornerRadius: 20))
                                }
                                Spacer()
                                    .frame(height: 150)
                            }
                            .padding(.horizontal, 16)
                        }
                        bottomButtomView
                            .padding(.horizontal, 16)
                        if store.isLoading {
                            skeletonView
                                .padding(.horizontal, 16)
                        }
                    }
                    .loadingFailure(didFailToLoad: store.didFailToLoad) {
                        store.send(.view(.retryButtonTapped))
                    }
                }
            }
            .toast(state: $store.toastState, position: .top)
            .task {
                store.send(.viewCycling(.onAppear))
            }
        }
    }
    @ViewBuilder
    var skeletonView: some View {
        WithPerceptionTracking {
            ZStack {
                Color.white
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        HStack(spacing: 0) {
                            Text("목표 상세보기")
                                .foregroundStyle(.clear)
                            Rectangle()
                                .frame(width: 8, height: 8)
                        }
                        .overlay {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Colors.grey200)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    }
                    Spacer()
                        .frame(height: 4)
                    VStack(spacing: 20) {
                        LabelView(
                            title: "목표명",
                            isLoading: true,
                            content: "마루와 함께하는 백엔드 서버 찐천재 목표"
                        )
                        LabelView(
                            title: "멘토",
                            isLoading: true,
                            content: "마루"
                        )
                        VStack {
                            LabelView(
                                title: "진행기간",
                                isLoading: true,
                                content: "20일"
                            )
                            RoundedRectangle(cornerRadius: 4)
                                .fill(.white)
                                .frame(width: 100, height: 40)
                                .padding(.leading, 90)
                        }
                    }
                    Spacer()
                        .frame(height: 30)
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Colors.grey200)
                        .frame(height: 100)
                    Spacer()
                        .frame(height: 16)
                    Text(" ")
                        .pretendardStyle(
                            .semiBold,
                            size: 16,
                            color: Colors.grey900
                        )
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Colors.grey200)
                        .clipShape(.rect(cornerRadius: 20))
                    Spacer()
                }
            }
        }
    }

    @ViewBuilder
    var goalDetailView: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button {
                        store.send(.view(.moreDetailButtonTapped))
                    } label: {
                        HStack {
                            Text("목표 상세보기")
                                .pretendardStyle(
                                    .regular,
                                    size: 12,
                                    color: Colors.grey600
                                )
                            Image(systemName: "chevron.right")
                                .resized(length: 8)
                        }
                        .foregroundStyle(Colors.grey800)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    }
                }
                Spacer()
                    .frame(height: 30)
                VStack(spacing: 20) {
                    LabelView(
                        title: "목표",
                        isLoading: store.isLoading,
                        content: store.content?.title
                    )
                    LabelView(
                        title: "멘토",
                        isLoading: store.isLoading,
                        content: store.content?.mentorName
                    )
                    VStack(alignment: .leading, spacing: 4) {
                        let startDate = store.content?.startDate ?? ""
                        let endDate = store.content?.endDate ?? ""
                        let day = calculatePeriodInDays(
                            startDate: startDate,
                            endDate: endDate)
                        LabelView(
                            title: "진행기간",
                            isLoading: store.isLoading,
                            content: "\(day)일"
                        )
                        HStack(alignment: .top, spacing: 10) {
                            Images.calendarP
                                .resized(length: 24)
                            let startDate = startDate
                                .convertDateString(toFormat: "yyyy년 MM월 dd일")
                            let endDate = endDate
                                .convertDateString(toFormat: "yyyy년 MM월 dd일")
                            Text("\(startDate ?? "") 부터\n\(endDate ?? "") 까지")
                                .pretendard(
                                    .medium,
                                    size: 14,
                                    color: Colors.grey600
                                )
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(12)
                        .background(Colors.grey50)
                        .clipShape(.rect(cornerRadius: 12))
                        .padding(.leading, 90)
                    }
                    HStack(alignment: .top, spacing: 30) {
                        Text("달성율")
                            .pretendard(
                                .semiBold,
                                size: 16,
                                color: Colors.grey600)
                            .frame(
                                minWidth: 60,
                                alignment: .leading)
                            .padding(.top, 12)
                        LinearProgressView(
                            isShowFlag: true,
                            progress:
                                Double(store.content?.totalCompletedCount ?? 0) /
                                Double(store.content?.totalTodoCount ?? 1),
                            progressColor: Colors.primary,
                            backgroundColor: Colors.primary50,
                            lineWidth: 14
                        )
                        .padding(.top, 14)
                    }
                }
            }
        }
    }

    @ViewBuilder
    var commentView: some View {
        VStack(spacing: 16) {
            Text("to. 김골메이트")
                .frame(maxWidth: .infinity, alignment: .leading)
                .pretendard(.regular, size: 16, color: Colors.primary900)
            Text("김골메이트님!\n30일동안 고생 많았어요~! 어떠셨어요? 조금 힘들었죠? 앞으로도 응원할게요!김골메이트님!".splitCharacters())
                .pretendardStyle(.regular, size: 15)
                .lineSpacing(4)
            Text("from. ANNA")
                .frame(maxWidth: .infinity, alignment: .trailing)
                .pretendard(.regular, size: 16, color: Colors.primary900)
        }
        .padding(24)
        .background(Color(hex: "FBFFF5"))
        .cornerRadius(30, corners: .allCorners)
        .overlay {
            RoundedRectangle(cornerRadius: 30)
                .stroke(Colors.grey100, lineWidth: 3)
        }
    }

    @ViewBuilder
    var bottomButtomView: some View {
        VStack(spacing: 0) {
            Spacer()
            Button {
                store.send(.view(.nextGoalButtonTapped))
            } label: {
                Text("다음 목표 시작하기")
                    .pretendard(
                        .medium,
                        size: 16,
                        color: .black
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Colors.primary)
                    .clipShape(.capsule)
            }
            Spacer()
                .frame(height: 16)
        }
        .frame(height: 112)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.white.opacity(0), .white, .white]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    func calculatePercentage(
        completed: Int?,
        total: Int?
    ) -> String {
        guard let completed,
              let total,
            total > 0
        else { return "-" }
        return String(Int(round(Double(completed) / Double(total) * 100)))
    }

    func calculatePeriodInDays(startDate: String?, endDate: String?) -> Int {
        guard let startDate, let endDate else { return -1 }
        let startDateObj = startDate.toDate(format: "yyyy-MM-dd")
        let endDateObj = endDate.toDate(format: "yyyy-MM-dd")
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: startDateObj)
        let endDay = calendar.startOfDay(for: endDateObj)
        let components = calendar.dateComponents(
            [.day], from: startDay, to: endDay)
        return (components.day ?? 0) + 1
    }
}

fileprivate struct LabelView: View {
    let title: String
    let isLoading: Bool
    let content: String?
    init(
        title: String,
        isLoading: Bool,
        content: String? = nil
    ) {
        self.title = title
        self.isLoading = isLoading
        self.content = content
    }
    var body: some View {
        WithPerceptionTracking {
            HStack(alignment: .top, spacing: 30) {
                Text(title)
                    .pretendard(.semiBold, size: 16, color: Colors.grey600)
                    .frame(minWidth: 60, alignment: .leading)
                    .overlay {
                        if isLoading {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Colors.grey200)
                        }
                    }
                Text(content ?? "")
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .pretendard(
                        .medium,
                        size: 16,
                        color: isLoading ?
                            .clear :
                            Colors.grey900
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay {
                        if isLoading {
                            HStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Colors.grey200)
                                Spacer()
                            }
                        }
                    }
            }
            .animation(
                .easeInOut(duration: 0.3),
                value: isLoading
            )
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    MyGoalCompletionView(
        store: Store(
            initialState: MyGoalCompletionFeature.State.init(
                contentId: 1
            ),
            reducer: {
                withDependencies {
                    $0.calendar = .current
                } operation: {
                    MyGoalCompletionFeature()
                }
            }
        )
    )
}
