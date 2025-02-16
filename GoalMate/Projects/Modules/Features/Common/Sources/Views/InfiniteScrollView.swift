//
//  InfiniteScrollView.swift
//  FeatureCommon
//
//  Created by Importants on 2/15/25.
//

import SwiftUI

public struct InfiniteScrollView<Content: View>: View {
    let content: Content
    let onLoadMore: () async -> Void

    public init(
        @ViewBuilder content: () -> Content,
        onLoadMore: @escaping () async -> Void
    ) {
        self.content = content()
        self.onLoadMore = onLoadMore
    }

    public var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                content
                GeometryReader { geo in
                    Color.clear
                        .preference(
                            key: OffsetPreferenceKey.self,
                            value: geo.frame(in: .named("scrollView")).minY
                        )
                }
                .frame(height: 20)
            }
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(OffsetPreferenceKey.self) { offset in
            Task {
                if offset < 50 {
                    await onLoadMore()
                }
            }
        }
    }
}

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
