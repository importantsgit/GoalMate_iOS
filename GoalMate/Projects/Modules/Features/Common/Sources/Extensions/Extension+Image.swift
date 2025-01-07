//
//  Extension+Image.swift
//  Common
//
//  Created by 이재훈 on 1/7/25.
//

import SwiftUI

public extension Images {
    static let logoSub = Asset.Assets.logoSub.swiftUIImage
    static let check = Asset.Assets.check.swiftUIImage
    static let kakaoLogo = Asset.Assets.kakaoLogo.swiftUIImage
    static let loginBanner = Asset.Assets.loginBanner.swiftUIImage
    static let loginSuccessBanner = Asset.Assets.loginSuccessBanner.swiftUIImage
}

public extension Image {
    init(appAsset: Images) {
        self.init(asset: appAsset)
    }

    /**
     이미지 리사이즈 (정사각형)
     */
    func resized(length: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: length, height: length)
    }

    /**
     이미지 리사이즈 (직사각형)
     */
    func resized(size: CGSize) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size.width, height: size.height)
    }
}
