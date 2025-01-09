//
//  Extension+View.swift
//  Common
//
//  Created by 이재훈 on 1/7/25.
//

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

    func loading(isLoading: Binding<Bool>) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
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
