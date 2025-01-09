//
//  Extension+Image.swift
//  FeatureCommon
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
    static let alarm = Asset.Assets.alarm.swiftUIImage
    static let goal = Asset.Assets.goal.swiftUIImage
    static let home = Asset.Assets.home.swiftUIImage
    static let myPage = Asset.Assets.myPage.swiftUIImage
    static let placeholder = Asset.Assets.placeholder.swiftUIImage
    static let back = Asset.Assets.back.swiftUIImage
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
