//
//  CircularProgressView.swift
//  FeatureCommon
//
//  Created by Importants on 2/22/25.
//

import SwiftUI

public struct CircularProgressView: View {
    var progress: Double
    let progressColor: Color
    let backgroundColor: Color

    public init(
        progress: Double,
        progressColor: Color,
        backgroundColor: Color
    ) {
        self.progress = progress
        self.progressColor = progressColor
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Circle
                Circle()
                    .fill(backgroundColor)
                // Progress Arc
                if progress < 1.0 {
                    makeCirclePath(
                        in: geometry,
                        progress: progress
                    )
                    .fill(progressColor)
                } else {
                    // When complete, show check mark
                    Circle()
                        .fill(progressColor)
                        .overlay {
                            Image(systemName: "checkmark")
                                .font(.system(size: geometry.size.width * 0.4))
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                        }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .animation(.easeInOut, value: progress)
    }
 
    private func makeCirclePath(in geometry: GeometryProxy, progress: Double) -> Path {
        let width = geometry.size.width
        let height = geometry.size.height
        let radius = width/2
        let start = CGPoint(x: width/2, y: 0)
        let center = CGPoint(x: width/2, y: height/2)
        var path = Path()
        path.move(to: start)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(270),
            endAngle: .degrees(270 + (180 * progress)),
            clockwise: false
        )
        path.addLine(to: center)
        path.addLine(to: start)
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
    VStack(spacing: 20) {
        CircularProgressView(
            progress: 0.3,
            progressColor: .green,
            backgroundColor: .green.opacity(0.2)
        )
        .frame(width: 40, height: 40)
        CircularProgressView(
            progress: 0.7,
            progressColor: .green,
            backgroundColor: .green.opacity(0.2)
        )
        .frame(width: 40, height: 40)
        CircularProgressView(
            progress: 1.0,
            progressColor: .green,
            backgroundColor: .green.opacity(0.2)
        )
        .frame(width: 40, height: 40)
    }
}
