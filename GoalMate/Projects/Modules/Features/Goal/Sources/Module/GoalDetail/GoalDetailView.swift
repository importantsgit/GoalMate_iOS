//
//  GoalDetailView.swift
//  FeatureGoal
//
//  Created by 이재훈 on 1/9/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI

struct GoalDetailView: View {
    @State var progress = 0.1
    @State var store: StoreOf<GoalDetailFeature>
    var body: some View {
        WithPerceptionTracking {
            ZStack {
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
                            if store.images.isEmpty {
                                Colors.grey200
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .aspectRatio(36/27, contentMode: .fit)
                            } else {
                                pageView
                            }
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
            .onAppear {
                store.send(.onAppear)
            }
            .sheet(isPresented: $store.isShowPurchaseView) {
                GoalDetailSheetView(store: store)
                    .presentationDetents([.height(370)])
            }
        }
    }
}

private extension GoalDetailView {
    @ViewBuilder
    var pageView: some View {
        WithPerceptionTracking {
            TabView(selection: $store.currentPage) {
                let images = store.images as [Image]
                ForEach(Array(images.enumerated()), id: \.offset) { image in
                    image.element
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tag(image.offset)
                        .background(Colors.grey200)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .overlay(alignment: .bottom) {
                // 커스텀 인디케이터
                let count = store.images.count
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
            if let content = store.content {
                VStack(spacing: 20) {
                    Group {
                        SeparatorView()
                        VStack(spacing: 8) {
                            LabelView(title: "목표 주제", content: content.details.goalSubject)
                            LabelView(title: "멘토명", content: content.details.mentor)
                            LabelView(title: "목표 기간", content: content.details.period)
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
                                        .pretendard(.semiBold, size: 13, color: Colors.secondaryY800)
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
                        .resized(length: 16)
                    Text("무료참여 ??자리 남았어요")
                        .pretendardStyle(
                            .regular,
                            size: 12,
                            color: Colors.grey900
                        )
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Colors.grey500, lineWidth: 1)
                )
                Button {
                    store.send(.startButtonTapped)
                } label: {
                    Text("목표 시작하기")
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
                    gradient: Gradient(colors: [.clear, .white]),
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

fileprivate struct GoalDetailSheetView: View {
    let store: StoreOf<GoalDetailFeature>
    var body: some View {
        WithPerceptionTracking {
            VStack {
                Rectangle()
                    .fill(Colors.grey300)
                    .frame(width: 32, height: 4)
                    .clipShape(.capsule)
                    .padding(.vertical, 16)
                Spacer()
                    .frame(height: 16)
                if let content = store.content {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top, spacing: 30) {
                            Text("목표")
                                .pretendardStyle(.medium, size: 16, color: Colors.grey500)
                            Text(content.details.goalSubject)
                                .pretendardStyle(.semiBold, size: 16, color: Colors.grey900)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack(alignment: .top, spacing: 30) {
                            Text("멘토")
                                .pretendardStyle(.medium, size: 16, color: Colors.grey500)
                            Text(content.details.mentor)
                                .pretendardStyle(.semiBold, size: 16, color: Colors.grey900)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        HStack(alignment: .top, spacing: 30) {
                            Text("가격")
                                .pretendardStyle(.medium, size: 16, color: Colors.grey500)
                            HStack(spacing: 10) {
                                Text("\(content.originalPrice)원")
                                    .pretendardStyle(.semiBold, size: 16, color: Colors.grey900)
                                    .strikethrough(
                                        color: Colors.grey900
                                    )
                                Text("\(content.discountedPrice)원")
                                    .pretendardStyle(.semiBold, size: 20, color: Colors.grey900)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Colors.grey300, lineWidth: 1)
                    )
                }
                Spacer()
                HStack(spacing: 19) {
                    Images.danger
                        .resized(length: 20)
                    VStack(alignment: .leading, spacing: 6) {
                        Text("유의해주세요")
                            .pretendard(.regular, size: 14, color: Colors.grey600)
                        Text("무료 참여 기회는 한 번 만 가능해요")
                            .pretendard(.medium, size: 16, color: Colors.grey900)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(20)
                .background(Colors.grey50)
                .clipShape(.rect(cornerRadius: 24))
                Spacer()
                Button {
                    store.send(.purchaseButtonTapped)
                } label: {
                    Text("목표 시작하기")
                        .pretendardStyle(
                            .medium,
                            size: 16,
                            color: .black
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Colors.primary)
                        .clipShape(.capsule)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    GoalDetailView(
        store: Store(
            initialState: GoalDetailFeature.State.init(
                contentId: "1"
            ),
            reducer: {
                GoalDetailFeature()
            }
        )
    )
}
