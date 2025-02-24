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
    static let myPage = Asset.Assets.myPage.swiftUIImage
    static let placeholder = Asset.Assets.placeholder.swiftUIImage
    static let back = Asset.Assets.back.swiftUIImage
    static let bell = Asset.Assets.bell.swiftUIImage
    static let comingSoon = Asset.Assets.comingSoon.swiftUIImage
    static let paymentCompleted = Asset.Assets.paymentCompleted.swiftUIImage
    static let warning = Asset.Assets.warning.swiftUIImage
    static let danger = Asset.Assets.danger.swiftUIImage
    static let goal = Asset.Assets.goal.swiftUIImage
    static let home = Asset.Assets.home.swiftUIImage
    static let profile = Asset.Assets.profile.swiftUIImage
    static let goalSeleceted = Asset.Assets.goalSelected.swiftUIImage
    static let homeSelected = Asset.Assets.homeSelected.swiftUIImage
    static let profileSelected = Asset.Assets.profileSelected.swiftUIImage
    static let calendarP = Asset.Assets.calendarP.swiftUIImage
    static let calendarCompleted = Asset.Assets.calendarCompleted.swiftUIImage
    static let goalCompleted = Asset.Assets.goalCompleted.swiftUIImage
    static let flag = Asset.Assets.flag.swiftUIImage
    static let progress = Asset.Assets.progress.swiftUIImage
    static let launchScreenLogo = Asset.Assets.launchScreenLogo.swiftUIImage
    static let pencil = Asset.Assets.pencil.swiftUIImage
    static let calendar = Asset.Assets.calendar.swiftUIImage
    static let commentSelected = Asset.Assets.commentSelected.swiftUIImage
    static let comment = Asset.Assets.comment.swiftUIImage
    static let cancel = Asset.Assets.cancel.swiftUIImage
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
