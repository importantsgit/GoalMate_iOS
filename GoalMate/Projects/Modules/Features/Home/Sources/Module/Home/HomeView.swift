//
//  HomeView.swift
//  Home
//
//  Created by Importants on 1/7/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI
import Utils

struct HomeView: View {
    @State var store: StoreOf<HomeFeature>

    var body: some View {
        WithPerceptionTracking {
            VStack {
                NavigationBar(
                    leftContent: {
                        Images.logoSub
                            .resized(size: .init(width: 84, height: 32))
                    }
                )
                ScrollView(.vertical) {
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
                                store.send(.contentTapped(content.id))
                            } label: {
                                getGoalContentCell(content: content)
                            }
                        }
                    }
                }
            }
            .setMargin()
            .onAppear {
                store.send(.onAppear)
            }
        }
    }

    @ViewBuilder
    func getGoalContentCell(content: GoalContent) -> some View {
        VStack(spacing: 10) {
            ZStack {
                CachedImageView(
                    store: .init(
                        initialState: CachedImageFeature.State.init(
                            url: content.imageURL
                        ),
                        reducer: {
                            CachedImageFeature()
                        }
                    )
                )
                if content.remainingCapacity == 0 {
                    Colors.grey300
                        .overlay {
                            Images.comingSoon
                                .resizable()
                                .aspectRatio(158/64, contentMode: .fit)
                        }
                }
            }
            .clipShape(.rect(cornerRadius: 4))
            .aspectRatio(158.0/118.0, contentMode: .fit)

            VStack(alignment: .leading, spacing: 8) {
                Text(content.title.splitCharacters())
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .multilineTextAlignment(.leading)
                    .pretendard(.semiBold, size: 18, color: Colors.grey900)
                    .frame(maxWidth: .infinity, alignment: .leading)
                AvailableTagView(
                    remainingCapacity: content.remainingCapacity,
                    currentParticipants: content.currentParticipants,
                    size: .small
                )
                if 1...10 ~= content.remainingCapacity {
                    TagView(
                        title: "마감임박",
                        backgroundColor: Colors.secondaryY700
                    )
                }

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
            }
            Spacer()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    HomeView(
        store: Store(
            initialState: HomeFeature.State.init(
                goalContents: GoalContent.dummies
            ),
            reducer: {
                HomeFeature()
            }
        )
    )
}
