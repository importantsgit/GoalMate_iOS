

import SwiftUI

public struct SemiCircle: View {
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
                Circle()
                    .fill(.red)
                    .frame(width: geometry.size.width)
                makeCirclePath(in: geometry)
                    .fill(.blue)
            }
        }
        .animation(.easeInOut, value: progress)
    }

    private func makeCirclePath(in geometry: GeometryProxy) -> Path {
        // 반지름
        let width = geometry.size.width
        let height = geometry.size.height
        let radius = width/2
        // 중앙
        let start = CGPoint(x: width/2, y: 0)
        let center = CGPoint(x: width/2, y: height/2)

        var path = Path()
        path.move(to: start)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: .degrees(270),
            endAngle: .degrees(180),
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
    SemiCircle(
        progress: .constant(0.5),
        progressColor: .blue,
        backgroundColor: .gray.opacity(0.2),
        lineWidth: 20
    )
    .frame(width: 200, height: 100)
}
