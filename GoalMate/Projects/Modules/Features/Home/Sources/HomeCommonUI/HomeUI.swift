//
//  HomeUI.swift
//  Home
//
//  Created by 이재훈 on 1/7/25.
//

import SwiftUI

internal extension View {
    @ViewBuilder
    func setMargin() -> some View {
        self.modifier(MarginModifier())
    }
}

fileprivate struct MarginModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
    }
}
