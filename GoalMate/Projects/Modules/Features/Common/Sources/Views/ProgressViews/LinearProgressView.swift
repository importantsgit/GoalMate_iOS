//
//  LinearProgressView.swift
//  FeatureCommon
//
//  Created by Importants on 1/17/25.
//

import SwiftUI

public struct LinearProgressView: View {
    var progress: Double
    let title: String?
    let isShowFlag: Bool
    let progressColor: Color
    let backgroundColor: Color
    let lineWidth: CGFloat

    public init(
        title: String? = nil,
        isShowFlag: Bool = false,
        progress: Double,
        progressColor: Color,
        backgroundColor: Color,
        lineWidth: CGFloat
    ) {
        self.title = title
        self.isShowFlag = isShowFlag
        self.progress = progress
        self.progressColor = progressColor
        self.backgroundColor = backgroundColor
        self.lineWidth = lineWidth
    }

    public var body: some View {
        VStack(spacing: 16) {
            if let title {
                HStack {
                    Text(title)
                        .pretendardStyle(.semiBold, size: 16, color: Colors.grey700)
                    Spacer()
                }
            }
            VStack(spacing: 4) {
                GeometryReader { geometry in
                    let width = min(max(calculateProgress(progress), 0), 1)
                    * geometry.size.width
                    ZStack(alignment: .leading) {
                        backgroundColor
                        Rectangle()
                            .fill(progressColor)
                            .frame(width: width)
                    }
                    .clipShape(
                        RoundedRectangle(cornerRadius: lineWidth/2)
                    )
                    .overlay {
                        if isShowFlag {
                            HStack {
                                Images.flagGreen
                                    .resized(size: .init(width: 16, height: 14))
                                Spacer()
                            }
                            .offset(
                                x: max(lineWidth/2,
                                       min(width-5, geometry.size.width-(lineWidth/2))),
                                y: -((lineWidth/2)+7))
                        }
                    }
                }
                .frame(height: lineWidth)
                .animation(.easeInOut, value: progress)
                HStack {
                    Spacer()
                    Text("\(Int(calculateProgress(progress) * 100))%")
                        .pretendardStyle(.semiBold, size: 16, color: Colors.grey700)
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
        isShowFlag: true,
        progress: 0.0,
        progressColor: .blue,
        backgroundColor: .gray.opacity(0.2),
        lineWidth: 20
    )
    .padding(30)
    LinearProgressView(
        isShowFlag: true,
        progress: 0.3,
        progressColor: .blue,
        backgroundColor: .gray.opacity(0.2),
        lineWidth: 20
    )
    .padding(30)
    LinearProgressView(
        isShowFlag: true,
        progress: 0.8,
        progressColor: .blue,
        backgroundColor: .gray.opacity(0.2),
        lineWidth: 20
    )
    .padding(30)
    LinearProgressView(
        isShowFlag: true,
        progress: 1,
        progressColor: .blue,
        backgroundColor: .gray.opacity(0.2),
        lineWidth: 20
    )
    .padding(30)
}
