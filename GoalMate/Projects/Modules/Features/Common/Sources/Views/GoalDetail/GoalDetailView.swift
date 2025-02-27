//
//  GoalDetailView.swift
//  FeatureGoal
//
//  Created by 이재훈 on 1/9/25.
//

import ComposableArchitecture
import SwiftUI

public struct GoalDetailView: View {
    @Perception.Bindable var store: StoreOf<GoalDetailFeature>
    public init(
        store: StoreOf<GoalDetailFeature>
    ) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .bottom) {
                VStack {
                    NavigationBar(
                        leftContent: {
                            Button {
                                store.send(.view(.backButtonTapped))
                            } label: {
                                VStack {
                                    Images.back
                                        .resized(length: 24)
                                }
                                .padding(.all, 12)
                            }
                        },
                        centerContent: {
                            Text("목표")
                                .pretendardStyle(
                                    .semiBold,
                                    size: 20,
                                    color: Color(hex: "212121")
                                )
                        }
                    )
                    .padding(.leading, 4)
                    .frame(height: 64)
                    ScrollView(.vertical) {
                        VStack(spacing: 0) {
                            pageView
                            Spacer()
                                .frame(height: 16)
                            VStack(spacing: 24) {
                                TitleView(store: store)
                                    .padding(.horizontal, 20)
                                GoalDescriptionView(store: store)
                            }
                            Spacer()
                                .frame(height: 120)
                        }
                    }
                    .scrollIndicators(.hidden)
                    .loadingFailure(didFailToLoad: store.didFailToLoad) {
                        store.send(.view(.retryButtonTapped))
                    }
                }
                if let content = store.content,
                   content.isParticipated == false {
                    BottomButtonView(store: store)
                }
                CustomPopup(
                    isPresented: $store
                        .isShowUnavailablePopup.sending(\.showUnavailablePopup),
                    leftButtonTitle: nil,
                    rightButtonTitle: "확인했습니다.",
                    leftAction: nil,
                    rightAction: {}
                ) {
                    VStack {
                        Spacer()
                            .frame(height: 50)
                        Images.warning
                            .resized(length: 24)
                        Spacer()
                            .frame(height: 10)
                        Text("무료 참여 기회를 이미 사용했어요.\n곧 결제 기능이 추가될 예정이에요")
                            .pretendard(
                                .medium,
                                size: 16,
                                color: Colors.grey800)
                        Spacer()
                            .frame(height: 40)
                    }
                }
            }
            .task {
                store.send(.viewCycling(.onAppear))
            }
            .toast(state: $store.toastState, position: .top)
        }
    }
}

private extension GoalDetailView {
    @ViewBuilder
    var pageView: some View {
        WithPerceptionTracking {
            Group {
                if let content = store.content {
                    let thumbnailImages = content.thumbnailImages.sorted { $0.id < $1.id }
                    TabView(selection: $store.currentPage) {
                        ForEach(thumbnailImages) { thumbnail in
                            Group {
                                if let imageURL = thumbnail.imageUrl {
                                    AsyncImage(
                                        url: URL(string: imageURL)
                                    ) { phase in
                                        switch phase {
                                        case .empty:
                                            ZStack {
                                                Rectangle()
                                                    .fill(Colors.grey200)
                                                ProgressView()
                                                    .progressViewStyle(.circular)
                                            }
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
                                } else {
                                    Images.placeholder
                                        .resizable()
                                }
                            }
                            .tag(thumbnail.id)
                            .background(Colors.grey200)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .overlay(alignment: .bottom) {
                        // 커스텀 인디케이터
                        let count = thumbnailImages.count
                        if count > 1 {
                            HStack(spacing: 8) {
                                ForEach(0..<count) { index in
                                    Circle()
                                        .stroke(Colors.grey300, lineWidth: 1)
                                        .frame(width: 8, height: 8)
                                        .background(
                                            Circle()
                                                .fill(
                                                    store.currentPage == index ?
                                                    Colors.grey900 :
                                                            .white
                                                )
                                        )
                                }
                            }
                            .padding(.bottom, 20)
                        }
                    }
                } else {
                    Colors.grey200
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .aspectRatio(36/27, contentMode: .fit)
            .animation(
                .easeInOut(duration: 0.3),
                value: store.isLoading
            )
        }
    }
}

fileprivate struct TitleView: View {
    let store: StoreOf<GoalDetailFeature>
    var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 8) {
                let title = store.content?.title ?? ""
                Text(title.splitCharacters() ?? " ")
                    .pretendardStyle(
                        .semiBold,
                        size: 22,
                        color: Colors.grey900
                    )
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .overlay {
                        if store.isLoading {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Colors.grey200)
                        }
                    }
                /*
                VStack(spacing: 6) {
                    HStack(spacing: 8) {
                        Text("\(content.discountPercentage)%")
                            .pretendardStyle(
                                .semiBold,
                                size: 14,
                                color: Colors.error
                            )
                        Text("\(content.originalPrice)원")
                            .pretendardStyle(
                                .semiBold,
                                size: 13,
                                color: Colors.grey500
                            )
                            .strikethrough(
                                color: Colors.grey500
                            )
                    }
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    Text("\(content.discountedPrice)원")
                        .pretendardStyle(
                            .semiBold,
                            size: 20
                        )
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }
                 */
                let currentParticipants = store.content?.currentParticipants ?? 0
                let remainingCapacity = ((store.content?.participantsLimit ?? 0) -
                                         currentParticipants)
                let isExpired = store.content?.goalStatus ?? .open
                AvailableTagView(
                    remainingCapacity: remainingCapacity,
                    currentParticipants: currentParticipants,
                    size: .large,
                    isExpired: isExpired == .closed
                )
                .overlay {
                    if store.isLoading {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.grey200)
                    }
                }
                if store.content?.isClosingSoon ?? false {
                    TagView(
                        title: "마감임박",
                        backgroundColor: Colors.secondaryY700
                    )
                }
            }
            .animation(
                .easeInOut(duration: 0.3),
                value: store.isLoading
            )
        }
    }
}

fileprivate struct GoalDescriptionView: View {
    let store: StoreOf<GoalDetailFeature>
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 20) {
                Group {
                    let period = store.content?.period ?? 0
                    SeparatorView()
                    VStack(spacing: 12) {
                        LabelView(
                            title: "목표 주제",
                            isLoading: store.isLoading,
                            content: store.content?.topic ?? ""
                        )
                        LabelView(
                            title: "멘토명",
                            isLoading: store.isLoading,
                            content: store.content?.mentorName ?? ""
                        )
                        LabelView(
                            title: "목표 기간",
                            isLoading: store.isLoading,
                            content: "\(period)일"
                        )
                        HStack(spacing: 0) {
                            Spacer()
                                .frame(width: 90)
                            HStack(alignment: .top, spacing: 10) {
                                Images.calendar
                                    .resized(length: 24)
                                VStack(alignment: .leading, spacing: 4) {
                                    let currentDate = Date()
                                    let startDateString = currentDate.getString()
                                    let endDate = Calendar.current.date(
                                        byAdding: .day,
                                        value: period,
                                        to: currentDate) ?? currentDate
                                    let endDateString = endDate.getString()
                                    Text("\(startDateString)에 시작해서")
                                    Text("\(endDateString)에 끝나요")
                                }
                                .pretendard(.medium, size: 14, color: Colors.grey600)
                            }
                            .padding(12)
                            .background(Colors.grey50)
                            .clipShape(.rect(cornerRadius: 12))
                            .overlay {
                                if store.isLoading {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Colors.grey200)
                                }
                            }
                            Spacer()
                        }
                        let duration = store.content?.dailyDuration ?? 0
                        LabelView(
                            title: "소요 기간",
                            isLoading: store.isLoading,
                            content: "하루 평균 \(duration)시간"
                        )
                    }
                    SeparatorView()
                }
                .padding(.horizontal, 20)
                VStack(spacing: 16) {
                    HStack {
                        Text("목표 설명")
                            .pretendard(
                                .semiBold,
                                size: 16,
                                color: Colors.grey500)
                            .overlay {
                                if store.isLoading {
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(Colors.grey200)
                                }
                            }
                        Spacer()
                    }
                    let description = store.content?.description ?? ""
                    Text(description.splitCharacters())
                        .pretendard(
                            .medium,
                            size: 16,
                            color: Colors.grey900)
                        .frame(maxWidth: .infinity)
                        .padding(20)
                        .background(Colors.grey50)
                        .clipShape(.rect(cornerRadius: 24))
                        .lineSpacing(3)
                }
                .padding(.horizontal, 20)
                SeparatorView(height: 16)
                if let content = store.content {
                    VStack(spacing: 16) {
                        HStack {
                            Text("주차별 목표")
                                .pretendard(.semiBold, size: 16, color: Colors.grey500)
                                .overlay {
                                    if store.isLoading {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Colors.grey200)
                                    }
                                }
                            Spacer()
                        }
                        VStack(spacing: 10) {
                            let weeklyObjectives = content.weeklyObjectives.sorted {
                                $0.id < $1.id
                            }
                            ForEach(weeklyObjectives) { goal in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("\(goal.weekNumber)주")
                                        .pretendard(.semiBold, size: 13, color: Colors.primary900)
                                        .padding(.vertical, 2)
                                        .frame(minWidth: 34)
                                        .background(Colors.primary50)
                                        .clipShape(.rect(cornerRadius: 6))
                                    let description = goal.description ?? ""
                                    Text(description.splitCharacters())
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                        .multilineTextAlignment(.leading)
                                        .pretendard(.medium, size: 16, color: Colors.grey800)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    SeparatorView(height: 16)
                    VStack(spacing: 16) {
                        HStack {
                            Text("중간 목표")
                                .pretendard(.semiBold, size: 16, color: Colors.grey500)
                                .overlay {
                                    if store.isLoading {
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(Colors.grey200)
                                    }
                                }
                            Spacer()
                        }
                        VStack(spacing: 10) {
                            let midObjectives = content.midObjectives.sorted {
                                $0.id < $1.id
                            }
                            ForEach(midObjectives) { goal in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("\(goal.sequence)")
                                        .pretendard(
                                            .semiBold,
                                            size: 13,
                                            color: Colors.secondaryY800
                                        )
                                        .padding(.vertical, 2)
                                        .frame(minWidth: 34)
                                        .background(Colors.secondaryY50)
                                        .clipShape(.rect(cornerRadius: 6))
                                    let description = goal.description ?? ""
                                    Text(description.splitCharacters())
                                        .lineLimit(2)
                                        .truncationMode(.tail)
                                        .multilineTextAlignment(.leading)
                                        .pretendard(.medium, size: 16, color: Colors.grey800)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    Spacer()
                        .frame(height: 30)
                    LazyVStack(spacing: 0) {
                        ForEach(content.contentImages) { image in
                            let imageURL = image.imageUrl ?? ""
                            AsyncImage(
                                url: URL(string: imageURL)
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
                                    EmptyView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Colors.grey200)
                        }
                    }
                } else {
                    EmptyView()
                }
            }
            .animation(
                .easeInOut(duration: 0.3),
                value: store.isLoading
            )
        }
    }
}

fileprivate struct BottomButtonView: View {
    let store: StoreOf<GoalDetailFeature>
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 10) {
                HStack(spacing: 4) {
                    Images.bell
                        .renderingMode(.template)
                        .resized(length: 16)
                        .foregroundStyle(Colors.grey800)
                    let remainingCapacity =
                        (store.content?.participantsLimit ?? 0) -
                        (store.content?.currentParticipants ?? 0)
                    Text("참여 가능한 자리가 \(remainingCapacity)자리 남았어요")
                        .pretendardStyle(
                            .regular,
                            size: 12,
                            color: Colors.grey900
                        )
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(.white)
                .clipShape(.rect(cornerRadius: 20))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Colors.grey500, lineWidth: 1)
                )
                let goalStatus = store.content?.goalStatus ?? .open
                let iaClosed = goalStatus == .closed
                Button {
                    if store.isLogin {
                        store.send(.view(.startButtonTapped))
                    } else {
                        store.send(.view(.loginButtonTapped))
                    }
                } label: {
                    Text(store.isLogin ?
                            "목표 시작하기" :
                            "지금 로그인하러 가기"
                    )
                        .pretendardStyle(
                            .medium,
                            size: 16,
                            color: iaClosed ?
                                .white : .black
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            iaClosed ?
                                Colors.grey300 :
                                Colors.primary
                        )
                        .clipShape(.capsule)
                }
                .padding(.horizontal, 20)
                .disabled(iaClosed)
                Spacer()
                    .frame(height: 16)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.white.opacity(0), .white, .white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
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
            HStack(spacing: 30) {
                Text(title)
                    .pretendard(.semiBold, size: 16, color: Colors.grey500)
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
                    .pretendard(.semiBold, size: 16, color: Colors.grey900)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .overlay {
                        if isLoading {
                            HStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Colors.grey200)
                                    .frame(width: 100)
                                Spacer()
                            }

                        }
                    }
                Spacer()
                    .frame(minWidth: 0)
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
    GoalDetailView(
        store: Store(
            initialState: GoalDetailFeature.State.init(
                contentId: 1
            ),
            reducer: {
                GoalDetailFeature()
            }
        )
    )
}
