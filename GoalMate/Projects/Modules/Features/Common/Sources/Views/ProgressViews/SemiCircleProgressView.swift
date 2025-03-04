//
//  SemiCircleProgressView.swift
//  FeatureCommon
//
//  Created by Importants on 1/17/25.
//

import ComposableArchitecture
import SwiftUI

public struct SemiCircleProgressView: View {
    @State var isOnAppear: Bool
    var progress: Double
    let progressColor: Color
    let backgroundColor: Color
    let lineWidth: CGFloat

    public init(
        progress: Double,
        progressColor: Color,
        backgroundColor: Color,
        lineWidth: CGFloat
    ) {
        self.progress = progress
        self.progressColor = progressColor
        self.backgroundColor = backgroundColor
        self.lineWidth = lineWidth
        self.isOnAppear = false
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 24) {
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
                                to: isOnAppear ? min(max(calculateProgress(progress), 0), 1) : 0
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
                                .pretendardStyle(.semiBold, size: 20, color: Colors.grey700)
                            Spacer()
                                .frame(height: 20)
                        }
                    }
                }
                .aspectRatio(2/1, contentMode: .fit)
                .frame(width: 200, height: 100)
                Text(text)
                    .pretendardStyle(
                        .medium,
                        size: 14,
                        color: Colors.grey800
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 45)
                    .background(.white)
                    .clipShape(.rect(cornerRadius: 14))
                    .overlay {
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color(hex: "f5f5f5"), lineWidth: 1)
                    }
                    .onAppear {
                        isOnAppear = true
                    }
            }
            .animation(.easeInOut, value: progress)
            .animation(.easeInOut, value: isOnAppear)
        }
    }

    private var text: String {
        switch progress {
        case 0.0..<0.1:
            return "미션을 시작해주세요."
        case 0.1..<0.2:
            return "시작이 반이에요!"
        case 0.2..<0.4:
            return "좋아요. 잘하고 있어요!"
        case 0.4..<0.6:
            return "벌써 절반이에요!"
        case 0.6..<0.8:
            return "조금만 더 힘내요. 얼마 안 남았어요!"
        case 0.8..<0.99:
            return "마무리까지 힘내요!"
        case 0.99...1:
            return "수고했어요! 오늘의 목표를 완료했어요!"
        default: return ""
        }
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
        progress: 0.5,
        progressColor: .blue,
        backgroundColor: .gray.opacity(0.2),
        lineWidth: 20
    )
    .frame(width: 200, height: 100)
}
