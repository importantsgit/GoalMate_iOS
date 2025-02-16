//
//  PaymentCompletedItem.swift
//  FeatureHome
//
//  Created by Importants on 1/20/25.
//

import Foundation

public struct PaymentCompletedContent: Identifiable, Equatable {
    public let contentId: Int
    public let title: String        // 목표
    public let mentor: String             // 멘토
    public let originalPrice: Int         // 원래 가격
    public let discountedPrice: Int       // 할인된 가격

    public init(
        contentId: Int,
        title: String,
        mentor: String,
        originalPrice: Int,
        discountedPrice: Int
    ) {
        self.contentId = contentId
        self.title = title
        self.mentor = mentor
        self.originalPrice = originalPrice
        self.discountedPrice = discountedPrice
    }
}

extension PaymentCompletedContent {
    public typealias ID = Int
    public var id: Int { contentId }
    static var dummy: PaymentCompletedContent {
        .init(
            contentId: 1,
            title: "영어",
            mentor: "다온",
            originalPrice: 100000,
            discountedPrice: 0
        )
    }
}
