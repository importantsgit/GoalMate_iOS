//
//  Extension+View.swift
//  Common
//
//  Created by 이재훈 on 1/7/25.
//

import ComposableArchitecture
import SwiftUI

public extension View {
    /**
     Text에 Pretendard font, Color 적용
     */
    func pretendard(
        _ font: IFont.Pretendard,
        size: CGFloat,
        color: Color? = nil
    ) -> some View {
        modifier(FontModifier(size: size, font: font, color: color))
    }

    func loading(isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }

    func customSheet(
        heights: [CGFloat] = [340],
        radius: CGFloat,
        corners: UIRectCorner
    ) -> some View {
        modifier(RoundSheetModifier(heights: heights, radius: radius, corners: corners))
    }

    func cornerRadius(
        _ radius: CGFloat,
        corners: UIRectCorner
    ) -> some View {
        modifier(CornerRoundedModifier(radius: radius, corners: corners))
    }

    func toast(
        state: Binding<ToastState>,
        position: ToastPosition = .bottom
    ) -> some View {
        modifier(ToastModifier(
            state: state,
            position: position
        ))
    }

    func loadingFailure(
        didFailToLoad: Bool,
        retryAction: @escaping () -> Void
    ) -> some View {
        modifier(
            LoadingFailureModifier(
                didFailToLoad: didFailToLoad,
                retryAction: retryAction
            )
        )
    }

    func hideWithScreenshot() -> some View {
        modifier(HideWithScreenshot())
    }
}

public extension Text {
    func pretendardStyle(
        _ weight: IFont.Pretendard,
        size: CGFloat,
        color: Color? = nil
    ) -> Text {
        self
            .font(weight.value.swiftUIFont(size: size))
            .foregroundColor(color ?? .black)
    }
}
