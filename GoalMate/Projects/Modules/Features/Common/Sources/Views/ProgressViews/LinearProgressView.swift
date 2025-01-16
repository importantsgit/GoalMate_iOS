//
//  LinearProgressView.swift
//  FeatureCommon
//
//  Created by Importants on 1/17/25.
//

import SwiftUI

public struct LinearProgressView: View {
    @Binding var progress: Double
    let title: String?
    let progressColor: Color
    let backgroundColor: Color
    let lineWidth: CGFloat

    public init(
        title: String? = nil,
        progress: Binding<Double>,
        progressColor: Color,
        backgroundColor: Color,
        lineWidth: CGFloat
    ) {
        self.title = title
        self._progress = progress
        self.progressColor = progressColor
        self.backgroundColor = backgroundColor
        self.lineWidth = lineWidth
    }

    public var body: some View {
        VStack(spacing: 16) {
            if let title {
                HStack {
                    Text(title)
                        .pretendardStyle(.semiBold, size: 16, color: Colors.gray700)
                    Spacer()
                }
            }
            VStack(spacing: 4) {
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        backgroundColor
                        Rectangle()
                            .fill(progressColor)
                            .frame(
                                width:
                                    min(
                                        max(
                                            calculateProgress(progress),
                                            0
                                        ),
                                        1
                                    ) * geometry.size.width
                            )
                    }
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: lineWidth/2)
                )
                .frame(height: lineWidth)
                .animation(.easeInOut, value: progress)
                HStack {
                    Spacer()
                    Text("\(Int(calculateProgress(progress) * 100))%")
                        .pretendardStyle(.semiBold, size: 16, color: Colors.gray700)
                }
            }
        }
    }

    private func calculateProgress(_ value: Double) -> Double {
        if value <= 0 { return 0 }
        let result = ceil(value * 10) / 10
        return min(result, 1.0)
    }
}

@available(iOS 17.0, *)
#Preview {
    LinearProgressView(
        title: "전체 진척율",
        progress: .constant(0.0),
        progressColor: .blue,
        backgroundColor: .gray.opacity(0.2),
        lineWidth: 20
    )
    .padding(30)
    LinearProgressView(
        progress: .constant(0.3),
        progressColor: .blue,
        backgroundColor: .gray.opacity(0.2),
        lineWidth: 20
    )
    .padding(30)
    LinearProgressView(
        progress: .constant(0.8),
        progressColor: .blue,
        backgroundColor: .gray.opacity(0.2),
        lineWidth: 20
    )
    .padding(30)
    LinearProgressView(
        progress: .constant(1),
        progressColor: .blue,
        backgroundColor: .gray.opacity(0.2),
        lineWidth: 20
    )
    .padding(30)
}
