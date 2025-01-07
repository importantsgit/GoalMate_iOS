//
//  Modifiers.swift
//  Common
//
//  Created by 이재훈 on 1/7/25.
//

import SwiftUI

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
