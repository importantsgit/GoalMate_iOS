//
//  SeparatorView.swift
//  FeatureCommon
//
//  Created by Importants on 1/20/25.
//

import SwiftUI

public struct SeparatorView: View {
    var height: CGFloat
    public init(
        height: CGFloat = 1
    ) {
        self.height = height
    }
    public var body: some View {
        Rectangle()
            .fill(Colors.grey50)
            .frame(maxWidth: .infinity)
            .frame(height: height)
    }
}
