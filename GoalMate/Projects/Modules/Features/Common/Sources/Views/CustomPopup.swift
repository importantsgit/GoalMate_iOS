//
//  CustomPopup.swift
//  FeatureCommon
//
//  Created by Importants on 2/22/25.
//

import SwiftUI

public struct CustomPopup<Content: View>: View {
    @Binding var isPresented: Bool
    let leftButtonTitle: String?
    let rightButtonTitle: String?
    let content: Content
    let leftAction: (() -> Void)?
    let rightAction: (() -> Void)?
    @State private var opacity: Double = 0
    @State private var scale: CGFloat = 0.8
    public init(
        isPresented: Binding<Bool>,
        leftButtonTitle: String? = nil,
        rightButtonTitle: String? = nil,
        leftAction: (() -> Void)? = nil,
        rightAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
        self.leftAction = leftAction
        self.rightAction = rightAction
        self.content = content()
    }
    public var body: some View {
        ZStack {
            if isPresented {
                Color.black
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismissWithAnimation()
                    }
                VStack(spacing: 20) {
                    content
                        .padding(.horizontal, 16)
                        .padding(.top, 46)
                        .padding(.bottom, 16)
                    HStack(spacing: 12) {
                        if let leftButtonTitle = leftButtonTitle {
                            Button(action: {
                                leftAction?()
                                dismissWithAnimation()
                            }) {
                                Text(leftButtonTitle)
                                    .pretendardStyle(
                                        .regular,
                                        size: 16,
                                        color: Colors.grey900
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background {
                                        RoundedRectangle(cornerRadius: .infinity)
                                            .stroke(
                                                Colors.grey300,
                                                lineWidth: 2
                                            )
                                    }
                                    .clipShape(.capsule)
                            }
                        }
                        if let rightButtonTitle = rightButtonTitle {
                            Button(action: {
                                rightAction?()
                                dismissWithAnimation()
                            }) {
                                Text(rightButtonTitle)
                                    .pretendardStyle(
                                        .regular,
                                        size: 16
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Colors.primary)
                                    .clipShape(.capsule)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }
                .background(Color.white)
                .cornerRadius(30)
                .padding(.horizontal, 40)
                .opacity(opacity)
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(.spring(duration: 0.2)) {
                        opacity = 1
                        scale = 1
                    }
                }
            }
        }
        .animation(.spring(), value: isPresented)
    }
    private func dismissWithAnimation() {
        Task {
            withAnimation(.spring(duration: 0.2)) {
                opacity = 0
                scale = 0.8
            }
            try await Task.sleep(nanoseconds: 200_000_000)
            isPresented = false
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    CustomPopup(
        isPresented: .constant(true),
        leftButtonTitle: "취소",
        rightButtonTitle: "확인",
        leftAction: {
            print("Left button tapped")
        },
        rightAction: {
            print("Right button tapped")
        }
    ) {
        Text("이미 지나간 날짜는\n완료 표시할 수 없어요 :(")
            .multilineTextAlignment(.center)
            .pretendard(
                .semiBold,
                size: 16,
                color: Colors.grey600
            )
            .frame(height: 110)
    }
}
