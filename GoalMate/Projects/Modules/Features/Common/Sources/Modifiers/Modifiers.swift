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

public enum ToastPosition { // 추가
    case top, bottom
    var edge: Edge {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        }
    }
    var alignment: Alignment {
        switch self {
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}

public enum ToastState: Equatable {
    case display(String)
    case hide
    public static func == (lhs: ToastState, rhs: ToastState) -> Bool {
        switch (lhs, rhs) {
            case (.display(let lhsText), .display(let rhsText)):
            return lhsText == rhsText
        case (.hide, .hide):
            return true
        default:
            return false
        }
    }
}
struct ToastModifier: ViewModifier {
    @Binding var state: ToastState
    let position: ToastPosition
    @State private var showToast = false
    @State private var currentTask: Task<Void, Never>?
    init(
        state: Binding<ToastState>,
        position: ToastPosition = .bottom
    ) {
        self.position = position
        self._state = state
    }
    func body(content: Content) -> some View {
        ZStack(alignment: position.alignment) {
            content
            if showToast {
                toastView
                    .transition(
                        .asymmetric(
                            insertion: .move(edge: .top),
                            removal: .move(edge: .top)
                        )
                    )
                    .onTapGesture {
                        withAnimation {
                            showToast = false
                        }
                    }
                    .zIndex(1)
            }
        }
        .onChange(of: state) { _ in
            if case .display = state {  // display 상태일 때만 새 Task 시작
                currentTask?.cancel()  // 이전 Task 취소
                currentTask = Task {
                    withAnimation {
                        showToast = true
                    }
                    try? await Task.sleep(for: .seconds(3))
                    if !Task.isCancelled {
                        withAnimation {
                            showToast = false
                        }
                        state = .hide
                    }
                }
            }
        }
    }
    @ViewBuilder
    var toastView: some View {
        if case let .display(message) = state {
            Text(message)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.8))
                )
                .padding(.horizontal, 20)
                .padding(
                    position == .top ? .top : .bottom,
                    30
                )
        }
    }
}
