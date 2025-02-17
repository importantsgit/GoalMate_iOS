//
//  GoalDetailView.swift
//  FeatureGoal
//
//  Created by 이재훈 on 1/9/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI

public struct GoalDetailView: View {
    @State var progress: Double
    @Perception.Bindable var store: StoreOf<GoalDetailFeature>
    init(
        progress: Double = 0.1,
        store: StoreOf<GoalDetailFeature>
    ) {
        self.progress = progress
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
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
                                .pretendardStyle(.semiBold, size: 20, color: Color(hex: "212121"))
                        }
                    )
                    .padding(.horizontal, 16)
                    .background(Color.white)
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
                }
                VStack {
                    Spacer()
                    BottomButtonView(store: store)
                }
                if store.isShowUnavailablePopup {
                    PopupView(isPresented: $store.isShowUnavailablePopup) {
                        VStack(spacing: 16) {
                            Images.warning
                                .resized(length: 24)
                            Text("무료 참여 기회를 이미 사용했어요.\n곧 결제 기능이 추가될 예정이에요")
                                .pretendard(.medium, size: 16, color: Colors.grey800)
                        }
                    } action: {
                    } label: {
                        Text("다른 목표 보러가기")
                            .pretendard(.medium, size: 16, color: .black)
                    }
                }
            }
            // onAppear로 동작 시, Concurrency하게 동작되지 않아 바로 Pop되는 현상 발생
            .task {
                store.send(.viewCycling(.onAppear))
            }
            .loading(isLoading: $store.isLoading)
            .toast(state: $store.toastState, position: .top)
        }
    }
}

private extension GoalDetailView {
    @ViewBuilder
    var pageView: some View {
        WithPerceptionTracking {
            TabView(selection: $store.currentPage) {
                if let content = store.content {
                    ForEach(
                        Array(content.thumbnailImages.enumerated()),
                        id: \.offset
                    ) { index, imageURL in
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
                                Image(systemName: "square.and.arrow.up")
                                    .foregroundColor(.gray)
                            @unknown default:
                                Rectangle()
                                    .fill(.black)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tag(index)
                        .background(Colors.grey200)
                    }
                } else {
                    Colors.grey200
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .overlay(alignment: .bottom) {
                // 커스텀 인디케이터
                let count = store.content?.thumbnailImages.count ?? 0
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
            .aspectRatio(36/27, contentMode: .fit)
        }
    }
}

fileprivate struct TitleView: View {
    let store: StoreOf<GoalDetailFeature>
    var body: some View {
        WithPerceptionTracking {
            if let content = store.content {
                VStack(alignment: .leading, spacing: 8) {
                    Text(content.details.title.splitCharacters())
                        .pretendardStyle(
                            .semiBold,
                            size: 22,
                            color: Colors.grey900
                        )
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
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
                    AvailableTagView(
                        remainingCapacity: content.remainingCapacity,
                        currentParticipants: content.currentParticipants,
                        size: .large
                    )
                    if 1...10 ~= content.remainingCapacity {
                        TagView(
                            title: "마감임박",
                            backgroundColor: Colors.secondaryY700
                        )
                    }
                }
            } else {
                // TODO: 로딩
                EmptyView()
            }
        }
    }
}

fileprivate struct GoalDescriptionView: View {
    let store: StoreOf<GoalDetailFeature>
    var body: some View {
        WithPerceptionTracking {
            if let content: GoalContentDetail = store.content {
                VStack(spacing: 20) {
                    Group {
                        SeparatorView()
                        VStack(spacing: 8) {
                            LabelView(title: "목표 주제", content: content.details.goalSubject)
                            LabelView(title: "멘토명", content: content.details.mentor)
                            LabelView(title: "목표 기간", content: content.details.period)
                            HStack(spacing: 0) {
                                Spacer()
                                    .frame(width: 90)
                                HStack(alignment: .top, spacing: 10) {
                                    Images.calendar
                                        .resized(length: 24)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(content.details.startDate)에 시작해서")
                                        Text("\(content.details.endDate)에 끝나요")
                                    }
                                    .pretendard(.medium, size: 14, color: Colors.grey600)
                                }
                                .padding(12)
                                .background(Colors.grey50)
                                .clipShape(.rect(cornerRadius: 12))
                                Spacer()
                            }
                        }
                        SeparatorView()
                    }
                    .padding(.horizontal, 20)
                    VStack(spacing: 16) {
                        LabelView(title: "목표 설명")
                        Text(content.details.goalDescription.splitCharacters())
                            .pretendard(.medium, size: 16, color: Colors.grey900)
                            .padding(20)
                            .background(Colors.grey50)
                            .clipShape(.rect(cornerRadius: 24))
                            .lineSpacing(3)
                    }
                    .padding(.horizontal, 20)
                    SeparatorView(height: 16)
                    VStack(spacing: 16) {
                        LabelView(title: "주차별 목표")
                        VStack(spacing: 10) {
                            ForEach(
                                Array(content.details.weeklyGoal.enumerated()),
                                id: \.offset
                            ) { goal in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("\(goal.offset+1)주")
                                        .pretendard(.semiBold, size: 13, color: Colors.primary900)
                                        .padding(.vertical, 2)
                                        .frame(minWidth: 34)
                                        .background(Colors.primary50)
                                        .clipShape(.rect(cornerRadius: 6))
                                    Text(goal.element.splitCharacters())
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
                        LabelView(title: "중간 목표")
                        VStack(spacing: 10) {
                            ForEach(
                                Array(content.details.milestoneGoal.enumerated()),
                                id: \.offset
                            ) { goal in
                                HStack(alignment: .top, spacing: 12) {
                                    Text("\(goal.offset+1)")
                                        .pretendard(
                                            .semiBold,
                                            size: 13,
                                            color: Colors.secondaryY800
                                        )
                                        .padding(.vertical, 2)
                                        .frame(minWidth: 34)
                                        .background(Colors.secondaryY50)
                                        .clipShape(.rect(cornerRadius: 6))
                                    Text(goal.element.splitCharacters())
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
                        ForEach(
                            Array(content.contentImages),
                            id: \.self
                        ) { imageURL in
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
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.gray)
                                @unknown default:
                                    Rectangle()
                                        .fill(.black)
                                }
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Colors.grey200)
                        }
                    }
                }
            } else {
                EmptyView()
            }
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
                    Text("무료참여 \(store.content?.remainingCapacity ?? 0)자리 남았어요")
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
                            color: store.content?.remainingCapacity == 0 ?
                                .white : .black
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(
                            store.content?.remainingCapacity == 0 ?
                            Colors.grey300 :
                                Colors.primary
                        )
                        .clipShape(.capsule)
                }
                .padding(.horizontal, 20)
                .disabled(store.content?.remainingCapacity == 0)
                Spacer()
                    .frame(height: 16)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.clear, .white, .white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

fileprivate struct LabelView: View {
    let title: String
    let content: String?
    init(
        title: String,
        content: String? = nil
    ) {
        self.title = title
        self.content = content
    }
    var body: some View {
        HStack(spacing: 30) {
            Text(title)
                .pretendard(.semiBold, size: 16, color: Colors.grey500)
                .frame(minWidth: 60, alignment: .leading)
            if let content {
                Text(content)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.leading)
                    .pretendard(.semiBold, size: 16, color: Colors.grey900)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
                .frame(minWidth: 0)
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
