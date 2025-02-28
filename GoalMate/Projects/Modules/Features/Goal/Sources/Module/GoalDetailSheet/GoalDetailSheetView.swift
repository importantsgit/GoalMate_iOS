//
//  GoalDetailSheetView.swift
//  FeatureGoal
//
//  Created by Importants on 2/16/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI

public struct GoalDetailSheetView: View {
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Perception.Bindable var store: StoreOf<GoalDetailSheetFeature>
    public init(store: StoreOf<GoalDetailSheetFeature>) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            VStack {
                Rectangle()
                    .fill(Colors.grey300)
                    .frame(width: 32, height: 4)
                    .clipShape(.capsule)
                    .padding(.vertical, 16)
                Spacer()
                    .frame(height: 16)
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 30) {
                        Text("목표")
                            .pretendardStyle(.medium, size: 16, color: Colors.grey500)
                        Text(store.content.title)
                            .pretendardStyle(.semiBold, size: 16, color: Colors.grey900)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HStack(alignment: .top, spacing: 30) {
                        Text("멘토")
                            .pretendardStyle(.medium, size: 16, color: Colors.grey500)
                        Text(store.content.mentor)
                            .pretendardStyle(.semiBold, size: 16, color: Colors.grey900)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    //                    HStack(alignment: .top, spacing: 30) {
                    //                        Text("가격")
                    //                            .pretendardStyle(.medium, size: 16, color: Colors.grey500)
                    //                        HStack(spacing: 10) {
                    //                            Text("\(store.originalPrice)원")
                    //                                .pretendardStyle(.semiBold, size: 16, color: Colors.grey900)
                    //                                .strikethrough(
                    //                                    color: Colors.grey900
                    //                                )
                    //                            Text("\(store.discountedPrice)원")
                    //                                .pretendardStyle(.semiBold, size: 20, color: Colors.grey900)
                    //                        }
                    //                        .frame(maxWidth: .infinity, alignment: .leading)
                    //                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Colors.grey300, lineWidth: 1)
                )
//                Spacer()
//                HStack(spacing: 19) {
//                    Images.danger
//                        .resized(length: 20)
//                    VStack(alignment: .leading, spacing: 6) {
//                        Text("유의해주세요")
//                            .pretendard(.regular, size: 14, color: Colors.grey600)
//                        Text("무료 참여 기회는 한 번 만 가능해요")
//                            .pretendard(.medium, size: 16, color: Colors.grey900)
//                    }
//                    Spacer()
//                }
//                .frame(maxWidth: .infinity)
//                .padding(20)
//                .background(Colors.grey50)
//                .clipShape(.rect(cornerRadius: 24))
                Spacer()
                Button {
                    store.send(.view(.purchaseButtonTapped))
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
            .padding(.bottom, safeAreaInsets.bottom)
            .toast(state: $store.toastState, position: .top)
        }
    }
}
