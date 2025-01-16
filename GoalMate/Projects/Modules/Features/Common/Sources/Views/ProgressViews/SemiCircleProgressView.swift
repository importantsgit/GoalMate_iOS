//
//  SemiCircleProgressView.swift
//  FeatureCommon
//
//  Created by Importants on 1/17/25.
//

import SwiftUI

public struct SemiCircleProgressView: View {
    @Binding var progress: Double
    let progressColor: Color
    let backgroundColor: Color
    let lineWidth: CGFloat

    public init(
        progress: Binding<Double>,
        progressColor: Color,
        backgroundColor: Color,
        lineWidth: CGFloat
    ) {
        self._progress = progress
        self.progressColor = progressColor
        self.backgroundColor = backgroundColor
        self.lineWidth = lineWidth
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                makeCirclePath(in: geometry)
                    .stroke(
                        backgroundColor,
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round
                        )
                    )
                makeCirclePath(in: geometry)
                    .trim(
                        from: 0,
                        to: min(max(calculateProgress(progress), 0), 1)
                    )
                    .stroke(
                        progressColor,
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round
                        )
                    )
                VStack {
                    Spacer()
                    Text("\(Int(calculateProgress(progress) * 100))%")
                        .pretendardStyle(.semiBold, size: 20, color: Colors.gray700)
                    Spacer()
                        .frame(height: 20)
                }
            }
        }
        .aspectRatio(2/1, contentMode: .fit)
        .animation(.easeInOut, value: progress)
    }

    private func makeCirclePath(in geometry: GeometryProxy) -> Path {
        // 반지름
        let width = geometry.size.width
        let height = geometry.size.height
        let radius = min(width/2, height) - lineWidth/2
        // 중앙
        let center = CGPoint(x: width/2, y: height)

        var path = Path()
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        return path
    }

    private func calculateProgress(_ value: Double) -> Double {
       if value <= 0 { return 0 }
       let result = ceil(value * 10) / 10
       return min(result, 1.0)
    }
}

@available(iOS 17.0, *)
#Preview {
    SemiCircleProgressView(
        progress: .constant(0.5),
        progressColor: .blue,
        backgroundColor: .gray.opacity(0.2),
        lineWidth: 20
    )
    .frame(width: 200, height: 100)
}
