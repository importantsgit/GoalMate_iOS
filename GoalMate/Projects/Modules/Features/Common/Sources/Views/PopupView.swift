//
//  PopupView.swift
//  FeatureCommon
//
//  Created by Importants on 1/20/25.
//

import SwiftUI

public struct PopupView<Content: View, LabelView: View>: View {
    @State private var opacity: Double = 0  // 초기 투명도
    @Binding var isPresented: Bool
    let content: Content
    let label: LabelView
    let action: () -> Void

    public init(
        isPresented: Binding<Bool>,
        @ViewBuilder content: () -> Content = { Spacer() },
        action: @escaping () -> Void,
        @ViewBuilder label: () -> LabelView = { Spacer() }
    ) {
        self._isPresented = isPresented
        self.content = content()
        self.action = action
        self.label = label()
    }

    public var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .onTapGesture {
                    Task {
                        opacity = 0
                        try await Task.sleep(for: .seconds(0.2))
                        isPresented = false
                    }
                }
            VStack {
                Spacer()
                    .frame(height: 36)
                Spacer()
                content
                Spacer()
                Button {
                    Task {
                        opacity = 0
                        try await Task.sleep(for: .seconds(0.2))
                        isPresented = false
                        action()
                    }
                } label: {
                    label
                        .pretendard(.medium, size: 16)
                        .lineLimit(nil)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Colors.primary)
                        .clipShape(.capsule)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 320)
            .padding(.bottom, 16)
            .padding(.horizontal, 16)
            .background(.white)
            .clipShape(.rect(cornerRadius: 30))
            .padding(.horizontal, 20)
        }
        .ignoresSafeArea(.all)
        .opacity(opacity)
        .transition(.opacity)
        .animation(.easeInOut(duration: 0.2), value: opacity)
        .onAppear {
            opacity = 1
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    PopupView(isPresented: .constant(true)) {
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
