//
//  CommentDetailView.swift
//  FeatureComment
//
//  Created by Importants on 2/23/25.
//

import ComposableArchitecture
import Data
import SwiftUI
import Utils

public struct CommentDetailView: View {
    // 높이 추적을 위한 PreferenceKey
    private struct TextEditorHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }

    // State 변수 추가
    @State private var textEditorHeight: CGFloat = 300
    @Bindable var store: StoreOf<CommentDetailFeature>
    public init(
        store: StoreOf<CommentDetailFeature>
    ) {
        self.store = store
    }
    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                VStack(spacing: 0) {
                    NavigationBar(
                        leftContent: {
                            Button {
                                store.send(.view(.backButtonTapped))
                            } label: {
                                Images.back
                                    .resized(length: 24)
                                    .frame(width: 48, height: 48)
                            }
                        },
                        centerContent: {
                            Text(store.title)
                                .pretendard(.semiBold, size: 20, color: Colors.grey900)
                                .lineLimit(1)
                                .truncationMode(.tail)
                                .frame(width: 300)
                        }
                    )
                    .frame(height: 64)
                    // Comments List
                    ScrollViewReader { proxy in
                        ScrollView {
                            WithPerceptionTracking {
                                if store.hasMorePages {
                                    Button {
                                        if store.isLoading == false {
                                            store.send(.view(.onLoadMore))
                                        }
                                    } label: {
                                        Text("과거 내용 불러오기")
                                            .pretendardStyle(.regular, size: 14, color: Colors.grey900)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 8)
                                            .background(Colors.primary)
                                            .clipShape(.rect(cornerRadius: 4))
                                    }
                                }
                                LazyVStack(spacing: 24) {
                                    ForEach(store.comments, id: \.id) { comment in
                                        VStack {
                                            if comment.writerRole == .mentee,
                                               let commentedAt = comment.commentedAt {
                                                let text = commentedAt.convertDateString(
                                                    fromFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
                                                    toFormat: "yyyy년 M월 dd일"
                                                )
                                                Spacer()
                                                    .frame(height: 20)
                                                HStack(spacing: 6) {
                                                    Text(text ?? "")
                                                        .pretendardStyle(
                                                            .medium,
                                                            size: 14,
                                                            color: Colors.grey700
                                                        )
                                                    let date = commentedAt.toDate(
                                                        format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                                                    )
                                                    let dateString = calculateDplus(fromDate: date)
                                                    Text("D+\(dateString)")
                                                        .pretendardStyle(
                                                            .semiBold,
                                                            size: 12,
                                                            color: .white
                                                        )
                                                        .padding(.horizontal, 4)
                                                        .padding(.vertical, 2)
                                                        .background(Colors.primary800)
                                                        .clipShape(.rect(cornerRadius: 4))
                                                }
                                            }
                                            CommentBubbleView(comment: comment)
                                        }
                                    }
                                    HStack { Spacer() }
                                        .id("Empty")
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 20)
                            }
                        }
                        .onTapGesture {
                            hideKeyboard()
                        }
                        .defaultScrollAnchor(.bottom)
                    }

                    // Input Area
                    VStack(spacing: 0) {
                        Divider()
                        HStack(spacing: 12) {
                            TextEditor(text: $store.input.sending(\.inputText))
                                .pretendard(.regular, size: 14, color: Colors.grey900)
                                .frame(height: min(80, max(35, textEditorHeight)))
                                .fixedSize(horizontal: false, vertical: true)
                                .scrollContentBackground(.hidden)
                                .background(
                                    GeometryReader { geometry in
                                        Color.clear.preference(
                                            key: TextEditorHeightKey.self,
                                            value: geometry.size.height
                                        )
                                    }
                                )
                                .onPreferenceChange(TextEditorHeightKey.self) { height in
                                    textEditorHeight = height
                                }
                                .overlay(
                                    Group {
                                        if store.input.isEmpty {
                                            Text("하루 1회, 300자 이만으로 작성해주세요:)")
                                                .pretendardStyle(.regular, size: 14, color: Colors.grey400)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 8)
                                        }
                                    },
                                    alignment: .topLeading
                                )
                            Button {
                                store.send(.view(.sendMessageButtonTapped))
                            } label: {
                                Image(systemName: "arrow.up")
                                    .resizable()
                                    .foregroundStyle(
                                        store.input.isEmpty ?
                                            .white :
                                            .black
                                    )
                                    .frame(width: 20, height: 20)
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(
                                                store.input.isEmpty ?
                                                    Colors.grey200 :
                                                    Colors.primary
                                            )
                                    )
                            }
                            .disabled(store.input.isEmpty)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()  // 오른쪽 정렬을 위한 Spacer
                                Button {
                                    hideKeyboard()
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .foregroundStyle(.gray)
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            }
                        }
                    }
                }
                .task {
                    store.send(.viewCycling(.onAppear))
                }
                CustomPopup(
                    isPresented: $store.isShowPopup.sending(\.dismissPopup),
                    rightButtonTitle: "확인했어요",
                    leftAction: nil,
                    rightAction: {}
                ) {
                    VStack {
                        Images.warning
                            .resized(length: 24)
                        Spacer()
                            .frame(height: 10)
                        Text("하루 한 번!")
                            .pretendardStyle(
                                .semiBold,
                                size: 18,
                                color: Colors.grey800
                            )
                        Spacer()
                            .frame(height: 10)
                        Text("하루 1회만 코멘트를 입력할 수 있어요.\n오늘 보낸 코멘트를 수정해주세요.")
                            .multilineTextAlignment(.center)
                            .pretendard(
                                .semiBold,
                                size: 16,
                                color: Colors.grey600
                            )
                    }
                }
            }
        }
    }

    func calculateDplus(fromDate: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: store.startDate)
        let startDate = calendar.startOfDay(for: fromDate)
        let components = calendar.dateComponents([.day], from: startDate, to: currentDate)
        return components.day ?? 0
    }
}

struct CommentBubbleView: View {
    let comment: CommentContent
    var body: some View {
        WithPerceptionTracking {
            HStack(spacing: 12) {
                if comment.writerRole == .mentee {
                    Spacer()
                        .frame(width: 90)
                }
                Text(comment.comment ?? "")
                    .pretendardStyle(.regular, size: 14, color: Colors.grey800)
                    .padding(20)
                    .background(
                        comment.writerRole == .mentor ?
                        Colors.grey50 :
                            Color(hex: "FBFFF5")
                    )
                    .cornerRadius(12)
                if comment.writerRole == .mentor {
                    Spacer()
                        .frame(width: 90)
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: comment.writerRole == .mentor ? .leading : .trailing)
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

@available(iOS 17.0, *)
#Preview {
    CommentDetailView(
        store: Store(
            initialState: CommentDetailFeature.State.init(
                roomId: 10, title: "sad", startDate: "2025-02-22T17:52:07.893Z"),
            reducer: {
                withDependencies {
                    $0.calendar = .current
                } operation: {
                    CommentDetailFeature()
                }
            }
        )
    )
}
