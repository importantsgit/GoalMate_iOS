//
//  PaymentCompletedItem.swift
//  FeatureHome
//
//  Created by Importants on 1/20/25.
//

import Foundation

public struct PaymentCompletedItem: Identifiable, Equatable {
    public let id: String
    public let goalSubject: String        // 목표
    public let mentor: String             // 멘토
    public let originalPrice: Int         // 원래 가격
    public let discountedPrice: Int       // 할인된 가격

    public init(
        id: String,
        goalSubject: String,
        mentor: String,
        originalPrice: Int,
        discountedPrice: Int
    ) {
        self.id = id
        self.goalSubject = goalSubject
        self.mentor = mentor
        self.originalPrice = originalPrice
        self.discountedPrice = discountedPrice
    }
}

extension PaymentCompletedItem {
    static var dummy: PaymentCompletedItem {
        .init(
            id: "1",
            goalSubject: "영어",
            mentor: "다온",
            originalPrice: 100000,
            discountedPrice: 0
        )
    }
}
