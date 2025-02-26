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
                Circle()
                    .fill(backgroundColor)
                if progress < 1.0 {
                    makeCirclePath(
                        in: geometry,
                        progress: calculateSteppedProgress(progress)
                    )
                    .fill(progressColor)
                } else {
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
            endAngle: .degrees(270 + (360 * progress)),
            clockwise: false
        )
        path.addLine(to: center)
        path.addLine(to: start)
        return path
    }

    private func calculateSteppedProgress(_ value: Double) -> Double {
        if value >= 1.0 { return 1.0 }
        if value <= 0 { return 0 }
        let percentage = value * 100
        if percentage < 10 {
            return 0.05 // 5% of 360°
        } else if percentage < 20 {
            return 0.10 // 10% of 360°
        } else if percentage < 30 {
            return 0.20 // 20% of 360°
        } else if percentage < 40 {
            return 0.30 // 30% of 360°
        } else if percentage < 50 {
            return 0.40 // 40% of 360°
        } else if percentage < 60 {
            return 0.50 // 50% of 360°
        } else if percentage < 70 {
            return 0.60 // 60% of 360°
        } else if percentage < 80 {
            return 0.70 // 70% of 360°
        } else if percentage < 90 {
            return 0.80 // 80% of 360°
        } else if percentage < 100 {
            return 0.90 // 90% of 360°
        } else {
            return 1.0 // 100% of 360°
        }
    }
}

@available(iOS 17.0, *)
#Preview {
    VStack(spacing: 20) {
        CircularProgressView(
            progress: 0.05, // 5%
            progressColor: .green,
            backgroundColor: .green.opacity(0.2)
        )
        .frame(width: 40, height: 40)
        CircularProgressView(
            progress: 0.15, // 15%
            progressColor: .blue,
            backgroundColor: .blue.opacity(0.2)
        )
        .frame(width: 40, height: 40)
        CircularProgressView(
            progress: 0.25, // 25%
            progressColor: .orange,
            backgroundColor: .orange.opacity(0.2)
        )
        .frame(width: 40, height: 40)
        CircularProgressView(
            progress: 0.75, // 75%
            progressColor: .purple,
            backgroundColor: .purple.opacity(0.2)
        )
        .frame(width: 40, height: 40)
        CircularProgressView(
            progress: 1.0, // 100%
            progressColor: .green,
            backgroundColor: .green.opacity(0.2)
        )
        .frame(width: 40, height: 40)
    }
}
