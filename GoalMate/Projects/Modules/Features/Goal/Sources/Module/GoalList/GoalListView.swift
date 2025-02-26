//
//  GoalListView.swift
//  FeatureGoal
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture
import Data
import FeatureCommon
import SwiftUI
import Utils

struct GoalListView: View {
    @State var store: StoreOf<GoalListFeature>
    init(store: StoreOf<GoalListFeature>) {
        self.store = store
    }
    var body: some View {
        WithPerceptionTracking {
            VStack {
                NavigationBar(
                    leftContent: {
                        Images.logoSub
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 88, height: 24)
                    }
                )
                .frame(height: 64)
                .padding(.horizontal, 20)
                ZStack {
                    goalListView
                    if store.isLoading {
                        skeletonView
                            .transition(.opacity)
                    }
                }
                .loadingFailure(didFailToLoad: store.didFailToLoad) {
                    store.send(.view(.retryButtonTapped))
                }
                .padding(.horizontal, 20)
                .onAppear {
                    store.send(.viewCycling(.onAppear))
                }
                .animation(
                    .easeInOut(duration: 0.2),
                    value: store.isLoading)
            }
        }
    }

    @ViewBuilder
    var goalListView: some View {
        WithPerceptionTracking {
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: .grid(2)),
                        GridItem(.flexible())
                    ],
                    alignment: .center,
                    spacing: 30
                ) {
                    ForEach(store.goalContents) { content in
                        Button {
                            store.send(.view(.contentTapped(content.id)))
                        } label: {
                            getGoalContentCell(content: content)
                        }
                        .task {
                            if store.isLoading == false &&
                                store.isScrollFetching &&
                                store.pagingationState.totalCount > 10 &&
                                store.goalContents[
                                    store.pagingationState.totalCount-10].id == content.id {
                                store.send(.view(.onLoadMore))
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
            .scrollIndicators(.hidden)
        }
    }

    @ViewBuilder
    var skeletonView: some View {
        VStack {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: .grid(2)),
                    GridItem(.flexible())
                ],
                alignment: .center,
                spacing: 30
            ) {
                ForEach(0...3, id: \.self) { _ in
                    VStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.grey200)
                            .aspectRatio(158/118, contentMode: .fill)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.grey200)
                            .frame(height: 20)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.grey200)
                            .frame(width: 100, height: 24)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.grey200)
                            .frame(width: 100, height: 24)
                    }
                }
            }
            Spacer()
        }
        .background(.white)
    }

    @ViewBuilder
    func getGoalContentCell(content: Goal) -> some View {
        WithPerceptionTracking {
            VStack(spacing: 10) {
                if let imageUrl = URL(string: content.mainImage ?? "") {
                     AsyncImage(
                         url: imageUrl
                     ) { phase in
                         switch phase {
                         case .empty:
                             Rectangle()
                                 .fill(Colors.grey200)
                                 .overlay {
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
                     .opacity(content.goalStatus == .closed ? 0.5 : 1)
                     .aspectRatio(158/118, contentMode: .fit)  // 컨테이너 비율 설정
                     .clipShape(.rect(cornerRadius: 4))
                     .overlay {
                         if content.goalStatus == .closed {
                             Images.comingSoon
                                 .resizable()
                                 .aspectRatio(156/55, contentMode: .fit)
                         }
                     }
                 } else {
                     Images.placeholder
                         .resizable()
                         .aspectRatio(contentMode: .fill)
                         .aspectRatio(158/118, contentMode: .fit)
                         .clipShape(.rect(cornerRadius: 4))
                 }

                VStack(alignment: .leading, spacing: 8) {
                    Text((content.title ?? "").splitCharacters())
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.leading)
                        .pretendard(.semiBold, size: 18, color: Colors.grey900)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    AvailableTagView(
                        remainingCapacity:
                            (content.participantsLimit ?? 0) -
                            (content.currentParticipants ?? 0),
                        currentParticipants: content.currentParticipants ?? 0,
                        size: .small
                    )
                    if content.isClosingSoon ?? false {
                        TagView(
                            title: "마감임박",
                            backgroundColor: Colors.secondaryY700
                        )
                    }
                    /*
                    VStack(spacing: 4) {
                        HStack(spacing: 4) {
                            HStack(spacing: 0) {
                                Text(
                                    content.discountPercentage,
                                    format: .number
                                        .precision(
                                            .fractionLength(0)
                                        )
                                )
                                Text("%")
                            }
                            .pretendard(
                                .medium,
                                size: 12,
                                color: Colors.secondaryP
                            )
                            Text("\(content.originalPrice)")
                                .pretendardStyle(
                                    .regular,
                                    size: 12,
                                    color: Colors.grey500
                                )
                                .strikethrough(color: Colors.grey400)
                            Spacer()
                        }
                        Text("\(content.discountedPrice)원")
                            .pretendardStyle(
                                .regular,
                                size: 16,
                                color: Colors.grey900
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                     */
                }
                Spacer()
            }
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    GoalListView(
        store: Store(
            initialState: .init(),
            reducer: {
                GoalListFeature()
            }
        )
    )
}
