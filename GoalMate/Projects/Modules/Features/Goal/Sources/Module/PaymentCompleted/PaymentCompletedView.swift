//
//  PaymentCompletedView.swift
//  FeatureHome
//
//  Created by Importants on 1/20/25.
//

import ComposableArchitecture
import FeatureCommon
import SwiftUI

struct PaymentCompletedView: View {
    var store: StoreOf<PaymentCompletedFeature>
    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
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
                    }
                )
                .frame(height: 64)
                Spacer()
                    .frame(height: 32)
                Images.paymentCompleted
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay {
                        VStack {
                            Spacer()
                                .frame(height: 60)
                            Text("반가워요,\n함께 목표까지 완주해요!")
                                .pretendardStyle(
                                    .semiBold,
                                    size: 18,
                                    color: Colors.grey900)
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                            Spacer()
                        }
                    }
                Spacer()
                    .frame(height: 16)
                VStack(alignment: .leading, spacing: 8) {
                    HStack(alignment: .top, spacing: 30) {
                        Text("목표")
                            .pretendardStyle(.medium, size: 16, color: Colors.grey900)
                        Text(store.content.title)
                            .pretendardStyle(.semiBold, size: 16, color: Colors.grey900)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    HStack(alignment: .top, spacing: 30) {
                        Text("멘토")
                            .pretendardStyle(.medium, size: 16, color: Colors.grey900)
                        Text(store.content.mentor)
                            .pretendardStyle(.semiBold, size: 16, color: Colors.grey900)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
//                    HStack(alignment: .top, spacing: 30) {
//                        Text("가격")
//                            .pretendardStyle(.medium, size: 16, color: Colors.grey900)
//                        HStack(spacing: 10) {
//                            Text("\(store.content.originalPrice)원")
//                                .pretendardStyle(.semiBold, size: 16, color: Colors.grey900)
//                                .strikethrough(
//                                    color: Colors.grey900
//                                )
//                            Text("\(store.content.originalPrice)원")
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
                Spacer()
                Button {
                    store.send(.view(.startButtonTapped))
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
            .setMargin()
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    PaymentCompletedView(
        store: Store(
            initialState: PaymentCompletedFeature.State.init(
                content: .dummy
            ),
            reducer: {
                PaymentCompletedFeature()
            }
        )
    )
}
