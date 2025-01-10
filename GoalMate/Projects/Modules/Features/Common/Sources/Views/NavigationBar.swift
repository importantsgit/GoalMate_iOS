//
//  NavigationBar.swift
//  Common
//
//  Created by 이재훈 on 1/7/25.
//

import SwiftUI

public struct NavigationBar<
    LeftContent: View,
    CenterContent: View,
    RightContent: View
>: View {
    let leftContent: LeftContent
    let centerContent: CenterContent
    let rightContent: RightContent

    public init(
        @ViewBuilder leftContent: () -> LeftContent = { Spacer() },
        @ViewBuilder centerContent: () -> CenterContent = { Spacer() },
        @ViewBuilder rightContent: () -> RightContent = { Spacer() }
    ) {
        self.leftContent = leftContent()
        self.centerContent = centerContent()
        self.rightContent = rightContent()
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 0) {
            leftContent
                .frame(maxWidth: .infinity, alignment: .leading)
            centerContent
                .frame(maxWidth: .infinity, alignment: .center)
            rightContent
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .frame(maxWidth: .infinity)
    }
}

@available(iOS 17.0, *)
#Preview {
    NavigationBar(
        leftContent: { Rectangle().fill(.red).frame(width: 20, height: 40) },
        centerContent: { Rectangle().fill(.red).frame(width: 100, height: 40) }
    )
    .background(.blue)
}
