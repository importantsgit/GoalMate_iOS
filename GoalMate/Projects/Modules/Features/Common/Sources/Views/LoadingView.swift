//
//  LoadingView.swift
//  Common
//
//  Created by 이재훈 on 1/7/25.
//

import SwiftUI

public struct LoadingView: View {
    public init() {}
    public var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .ignoresSafeArea()
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                .scaleEffect(1.5)
        }
    }
}
