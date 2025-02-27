//
//  Tags.swift
//  FeatureCommon
//
//  Created by Importants on 1/17/25.
//

import SwiftUI

public struct AvailableTagView: View {
    public enum Size {
        case small
        case large
    }
    let remainingCapacity: Int
    let currentParticipants: Int
    let size: Size
    let isExpired: Bool

    public init(
        remainingCapacity: Int,
        currentParticipants: Int,
        size: Size = .small,
        isExpired: Bool = false
    ) {
        self.remainingCapacity = remainingCapacity
        self.currentParticipants = currentParticipants
        self.size = size
        self.isExpired = isExpired
    }

    public var body: some View {
        let isLarge = size == .large
        HStack(spacing: isLarge ? 4 : 2) {
            HStack(spacing: 2) {
                Text("\(remainingCapacity)")
                    .pretendardStyle(
                        .medium,
                        size: isLarge ? 17 : 14,
                        color: .white
                    )
                Text("남음")
                    .pretendardStyle(
                        .medium,
                        size: isLarge ? 13 : 11,
                        color: .white
                    )
            }
            .padding(.leading, 8)
            .padding(.trailing, isLarge ? 10 : 8)
            .padding(.vertical, 3)
            .background {
                GeometryReader { geometry in
                    makeBackgroundPath(in: geometry)
                        .fill(
                            isExpired ?
                                Colors.grey500 :
                                Colors.secondaryP400
                        )
                }
            }
            HStack(spacing: 2) {
                Text("\(currentParticipants)")
                    .pretendardStyle(
                        .medium,
                        size: isLarge ? 17 : 14,
                        color: isExpired ?
                            Colors.grey600 :
                            Colors.secondaryP
                    )
                Text("참여중")
                    .pretendardStyle(
                        .medium,
                        size: isLarge ? 13 : 11,
                        color: isExpired ?
                            Colors.grey600 :
                            Colors.secondaryP
                    )
            }
        }
        .padding(.trailing, 8)
        .background(
            isExpired ?
                Colors.grey200 :
                Colors.secondaryP50
        )
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
    VStack {
        AvailableTagView(
            remainingCapacity: 10,
            currentParticipants: 20,
            size: .small
        )
        AvailableTagView(
            remainingCapacity: 0,
            currentParticipants: 20,
            size: .large
        )
        TagView(
            title: "마감임박",
            backgroundColor: Colors.secondaryY700
        )
    }
}
