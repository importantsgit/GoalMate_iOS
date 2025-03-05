//
//  CommentDetailView.swift
//  FeatureCommon
//
//  Created by Importants on 2/23/25.
//

import ComposableArchitecture
import Data
import SwiftUI
import Utils

public struct CommentDetailView: View {
    @Environment(\.safeAreaInsets) var safeAreaInsets
    @Perception.Bindable var store: StoreOf<CommentDetailFeature>
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
                                    .padding(.all, 12)
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
                    .frame(height: 52)
                    .padding(.horizontal, 4)
                    .onTapGesture {
                        store.send(.view(.hideKeyboard))
                    }
                    VStack(spacing: 0) {
                        ZStack {
                            // Comments List
                            CommentList(
                                comments: store.comments,
                                endDate: store.endDate
                            ) {
                                if store.pagingationState.hasMorePages &&
                                    store.isScrollFetching == false {
                                    store.send(.view(.onLoadMore))
                                }
                            } onLongPress: { (comment, points) in
                                let minY = points.0, maxY = points.1
                                let commentTop = minY - (safeAreaInsets.top + 64)
                                let commentBottom = maxY - (safeAreaInsets.top + 64)
                                store.send(.view(.showEditPopup(
                                    comment.id,
                                    (commentTop < 80 ?
                                            .bottom(commentBottom) :
                                            .top(commentTop-80)))))
                            }
                            .onTapGesture {
                                store.send(.view(.hideKeyboard))
                            }
                            if store.isLoading == false &&
                               store.comments.isEmpty {
                                Spacer()
                                Text("오늘의 고민과 질문을 남기고\n멘토 코멘트를 받아보세요:)")
                                    .pretendardStyle(
                                        .regular,
                                        size: 16,
                                        color: Colors.grey900
                                    )
                                    .lineSpacing(4)
                                    .multilineTextAlignment(.center)
                                Spacer()
                            }
                            if store.isLoading {
                                skeletonView
                                    .transition(.opacity)
                            }
                        }
                        textFieldView
                    }
                    .overlay {
                        if case let .display(commentId, position) = store.isShowEditPopup {
                            VStack {
                                if case let .top(padding) = position {
                                    Spacer()
                                        .frame(height: padding)
                                    HStack {
                                        Spacer()
                                        CommentPopupView(
                                            updateButtonTapped: {
                                                store.send(.view(
                                                    .editCommentButtonTapped(commentId)))
                                            },
                                            deleteButtonTapped: {
                                                store.send(.view(
                                                    .deleteButtonTapped(commentId)))
                                            }
                                        )
                                    }
                                    Spacer()
                                } else if case let .bottom(padding) = position {
                                    Spacer()
                                        .frame(height: padding)
                                    HStack {
                                        Spacer()
                                        CommentPopupView(
                                            updateButtonTapped: {
                                                store.send(.view(
                                                    .editCommentButtonTapped(commentId)))
                                            },
                                            deleteButtonTapped: {
                                                store.send(.view(
                                                    .deleteButtonTapped(commentId)))
                                            }
                                        )
                                    }
                                    Spacer()
                                }
                            }
                            .transition(.opacity)
                            .background {
                                if case .display = store.isShowEditPopup {
                                    Color.clear
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            store.send(.view(.dismissEditPopup))
                                        }
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        store.send(.view(.dismissEditPopup))
                    }
                }
                .task {
                    store.send(.viewCycling(.onAppear))
                }
                CustomPopup(
                    isPresented: $store.isShowLimitedSendingPopup
                        .sending(\.dismissLimitedSendingPopup),
                    rightButtonTitle: "확인했어요",
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
                        Text("하루 한 번!")
                            .pretendardStyle(
                                .semiBold,
                                size: 18,
                                color: Colors.grey800
                            )
                        Spacer()
                            .frame(height: 10)
                        Text("하루 1회만 코멘트를 입력 할 수 있어요.\n오늘 보낸 코멘트를 수정해주세요.")
                            .pretendardStyle(
                                .medium,
                                size: 14,
                                color: Colors.grey800
                            )
                        Spacer()
                            .frame(height: 40)
                    }
                }
            }
            .animation(.spring(duration: 0.2), value: store.isShowEditPopup)
            .animation(.easeInOut(duration: 0.1), value: store.isLoading)
        }
    }

    @ViewBuilder
    var skeletonView: some View {
        ScrollView {
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(width: 160, height: 20)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(height: 60)
                    .padding(.leading, 20)
                    .padding(.trailing, 120)
                Spacer()
                    .frame(height: 32)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(width: 160, height: 20)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(height: 100)
                    .padding(.trailing, 20)
                    .padding(.leading, 120)
                Spacer()
                    .frame(height: 32)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(height: 100)
                    .padding(.leading, 20)
                    .padding(.trailing, 120)
                Spacer()
                    .frame(height: 32)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(width: 160, height: 20)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(height: 100)
                    .padding(.trailing, 20)
                    .padding(.leading, 120)
                Spacer()
                    .frame(height: 32)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Colors.grey200)
                    .frame(height: 100)
                    .padding(.leading, 20)
                    .padding(.trailing, 120)
            }
        }
        .scrollIndicators(.hidden)
        .background(.white)
    }

    @ViewBuilder
    var textFieldView: some View {
        HStack(alignment: .top, spacing: 12) {
            TextField(
                "",
                text: $store.input.sending(\.inputText),
                prompt: Text("하루 1회, 300자 이만으로 작성해주세요:)")
                    .pretendardStyle(
                        .regular,
                        size: 16,
                        color: Colors.grey500),
                axis: .vertical
            )
            .pretendard(
                .regular,
                size: 16,
                color: Colors.grey900)
            .lineLimit(1...30)
            .lineSpacing(2)
            .frame(maxWidth: .infinity, minHeight: 24)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(Colors.grey300, lineWidth: 2)
                    .background(.white)
            )
            .disabled(store.isLoading)
            if case .edit(_, _) = store.isUpdateMode {
                Button {
                    store.send(.view(.editCancelButtonTapped))
                } label: {
                    Images.cancel
                        .resized(length: 20)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .fill(Colors.grey200)
                        )
                }
            }
            Button {
                store.send(.view(.sendMessageButtonTapped))
            } label: {
                Images.arrowUp
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .frame(width: 44, height: 44)
                    .foregroundStyle(
                        getTextFieldForgroundColor()
                    )
                    .background(
                        Circle()
                            .fill(getTextFieldButtonColor())
                    )
            }
            .disabled(store.input.isEmpty || store.isMessageProcessing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .overlay {
            if store.isSentCommentToday
                && store.isUpdateMode == .idle {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        store.send(.view(.showLimitedSendingPopup))
                    }
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()  // 오른쪽 정렬을 위한 Spacer
                Button {
                    store.send(.view(.hideKeyboard))
                } label: {
                    Image(systemName: "chevron.down")
                        .foregroundStyle(.gray)
                        .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }

    func getTextFieldForgroundColor() -> Color {
        if case let .edit(_, text) = store.isUpdateMode,
            text == store.input {
            return .white
        } else {
            return store.input.isEmpty ? .white : .black
        }
    }

    func getTextFieldButtonColor() -> Color {
        if case let .edit(_, text) = store.isUpdateMode,
            text == store.input {
            return Colors.grey200
        } else {
            return store.input.isEmpty ? Colors.grey200 : Colors.primary
        }
    }
}

fileprivate struct CommentPopupView: View {
    let updateButtonTapped: () -> Void
    let deleteButtonTapped: () -> Void
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 0) {
                Button {
                    updateButtonTapped()
                } label: {
                    VStack(spacing: 0) {
                        Text("수정")
                            .pretendard(.regular, size: 14, color: Colors.grey900)
                            .padding(.leading, 13)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 39)
                        Rectangle()
                            .fill(Color(hex: "E7E7E7"))
                            .frame(height: 1)
                    }
                }

                Button {
                    deleteButtonTapped()
                } label: {
                    Text("삭제")
                        .pretendard(.regular, size: 14, color: Colors.error)
                        .padding(.leading, 13)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 40)
                }
            }
            .frame(width: 238)
            .background(.white)
            .clipShape(.rect(cornerRadius: 14))
            .shadow(color: .black.opacity(0.1), radius: 30)
            .padding(.trailing, 20)
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    CommentDetailView(
        store: Store(
            initialState: CommentDetailFeature.State.init(
                roomId: 10, title: "sad", endDate: "2025-02-22T17:52:07.893Z"),
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
