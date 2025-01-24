//
//  SeparatorView.swift
//  FeatureCommon
//
//  Created by Importants on 1/20/25.
//

import SwiftUI

public struct SeparatorView: View {
    var height: CGFloat
    var color: Color
    public init(
        height: CGFloat = 1,
        color: Color = Colors.grey50
    ) {
        self.height = height
        self.color = color
    }
    public var body: some View {
        Rectangle()
            .fill(color)
            .frame(maxWidth: .infinity)
            .frame(height: height)
    }
}
