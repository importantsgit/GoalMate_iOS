//
//  Modifiers.swift
//  Common
//
//  Created by 이재훈 on 1/7/25.
//

import SwiftUI
import UIKit
import Utils

struct FontModifier: ViewModifier {
    let size: CGFloat
    let font: IFont.Pretendard
    let color: Color?

    func body(content: Content) -> some View {
        content
            .font(font.value.swiftUIFont(size: size))
            .foregroundStyle(color ?? .primary)
    }
}

struct LoadingModifier: ViewModifier {
    @Binding var isLoading: Bool

    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    LoadingView()
                }
            }
    }
}

struct RoundSheetModifier: ViewModifier {
    var heights: [CGFloat]
    var radius: CGFloat
    var corners: UIRectCorner
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    init(
        heights: [CGFloat] = [340],
        radius: CGFloat = .infinity,
        corners: UIRectCorner = .allCorners
    ) {
        self.heights = heights
        self.radius = radius
        self.corners = corners
    }

    func body(content: Content) -> some View {
        content
            .modifier(SheetModifier(heights: heights))
            .padding(.bottom, safeAreaInsets.bottom)
            .background(Color.white)
            .modifier(CornerRoundedModifier(radius: radius, corners: corners))
            .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct SheetModifier: ViewModifier {
    var heights: Set<PresentationDetent>
    init(heights: [CGFloat]) {
        self.heights = Set(heights.map {
            return PresentationDetent.height($0)
        })
    }
    func body(content: Content) -> some View {
        Group {
            if #available(iOS 16.4, *) {
                content
                    .presentationBackground(.clear)
            } else {
                content.background(ClearBackgroundView())
            }
        }
        .presentationDetents(heights)
    }
}

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}

struct CornerRoundedModifier: ViewModifier {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func body(content: Content) -> some View {
        content
            .clipShape(CornerRoundView(radius: radius, corners: corners))
    }
}

struct CornerRoundView: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
