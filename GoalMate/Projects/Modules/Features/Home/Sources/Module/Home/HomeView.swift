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
                                VStack(spacing: 10) {
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
                                    .aspectRatio(158.0/118.0, contentMode: .fit)
                                    VStack(spacing: 8) {
                                        Text(content.title)
                                            .lineLimit(2)
                                            .truncationMode(.tail)
                                            .pretendard(.semiBold, size: 18, color: Colors.gray900)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        VStack(spacing: 4) {
                                            HStack(spacing: 4) {
                                                HStack(spacing: 0) {
                                                    Text(
                                                        content.discountPercentage,
                                                        format: .number.precision(.fractionLength(0))
                                                    )
                                                    Text("%")
                                                }
                                                .pretendard(.semiBold, size: 14, color: Colors.gray400)
                                                Text("\(content.originalPrice)")
                                                    .pretendardStyle(
                                                        .semiBold,
                                                        size: 13,
                                                        color: Colors.gray400
                                                    )
                                                    .strikethrough(color: Colors.gray400)
                                                Spacer()
                                            }
                                            Text("\(content.discountedPrice)원")
                                                .pretendardStyle(
                                                    .medium,
                                                    size: 18,
                                                    color: Colors.gray900
                                                )
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        HStack(spacing: 4) {
                                            Images.alarm
                                                .resized(length: 16)
                                            Text("무료 참여")
                                                .pretendardStyle(
                                                    .medium,
                                                    size: 14,
                                                    color: Colors.gray700
                                                )
                                            HStack(spacing: 0) {
                                                Text("\(content.currentFreeParticipants)")
                                                    .pretendardStyle(
                                                        .medium,
                                                        size: 14,
                                                        color: Colors.primary800
                                                    )
                                                Text("/\(content.maxFreeParticipants)")
                                                    .pretendardStyle(
                                                        .medium,
                                                        size: 14,
                                                        color: Colors.gray400
                                                    )
                                                Text("명")
                                                    .pretendardStyle(
                                                        .medium,
                                                        size: 14,
                                                        color: Colors.gray400
                                                    )
                                            }
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                    Spacer()
                                }
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
