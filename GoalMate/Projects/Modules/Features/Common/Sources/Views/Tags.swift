//
//  Tags.swift
//  FeatureCommon
//
//  Created by Importants on 1/17/25.
//

import SwiftUI

public struct AvailableTagView: View {
    let capacity: Int
    let available: Int

    public init(capacity: Int, available: Int) {
        self.capacity = capacity
        self.available = available
    }

    public var body: some View {
        HStack(spacing: 2) {
            HStack(spacing: 2) {
                Text("\(capacity)")
                    .pretendardStyle(.bold, size: 14, color: .white)
                Text("잔여")
                    .pretendardStyle(.medium, size: 13, color: .white)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background {
                GeometryReader { geometry in
                    makeBackgroundPath(in: geometry)
                        .fill(Colors.secondaryP)
                }
            }
            HStack(spacing: 2) {
                Text("\(available)")
                    .pretendardStyle(.bold, size: 14, color: Colors.secondaryP)
                Text("참여중")
                    .pretendardStyle(.medium, size: 13, color: Colors.secondaryP)
            }
        }
        .padding(.trailing, 8)
        .background(Color.purple.opacity(0.2))
        .clipShape(.rect(cornerRadius: 6))
    }

    private func makeBackgroundPath(in geometry: GeometryProxy) -> Path {
        let width = geometry.size.width
        let height = geometry.size.height
        var path = Path()
        // 아래보다 더 좋은 방법
        /*path.addLines([
         .init(x: 0, y: 0),
         .init(x: width, y: 0),
         .init(x: width, y: height),
         .init(x: 0, y: height),
         .init(x: 0, y: 0)
         ])*/
        path.move(to: .init(x: 0, y: 0))
        path.addLine(to: .init(x: width, y: 0))
        path.addLine(to: .init(x: width-5, y: height))
        path.addLine(to: .init(x: 0, y: height))
        path.addLine(to: .init(x: 0, y: 0))
        return path
    }
}

public struct TagView: View {
    let title: String
    let backgroundColor: Color

    public init(
        title: String,
        backgroundColor: Color
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        Text(title)
            .pretendard(.medium, size: 12, color: .white)
            .padding(.vertical, 4)
            .padding(.horizontal, 6)
            .background(backgroundColor)
            .clipShape(.rect(cornerRadius: 4))
    }
}

@available(iOS 17.0, *)
#Preview {
    AvailableTagView(
        capacity: 10,
        available: 20
    )

    TagView(
        title: "마감임박",
        backgroundColor: .blue
    )
}
