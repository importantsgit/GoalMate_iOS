//
//  GoalUI.swift
//  Home
//
//  Created by 이재훈 on 1/7/25.
//

import SwiftUI

internal extension View {
    @ViewBuilder
    func setMargin() -> some View {
        self.modifier(
            MarginModifier(
                horizontal: 20,
                bottom: 16
            )
        )
    }

    func setHorizontalMargin() -> some View {
        self.modifier(
            MarginModifier(
                horizontal: 20
            )
        )
    }
}

fileprivate struct MarginModifier: ViewModifier {
    var horizontal: CGFloat
    var bottom: CGFloat

    init(
        horizontal: CGFloat = 0,
        bottom: CGFloat = 0
    ) {
        self.horizontal = horizontal
        self.bottom = bottom
    }

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontal)
            .padding(.bottom, bottom)
    }
}
