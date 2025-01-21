//
//  GoalContent.swift
//  FeatureHome
//
//  Created by 이재훈 on 1/9/25.
//

import Foundation

public struct GoalContent: Identifiable, Equatable {
    // 할인 관련
    public let id: String
    public let title: String              // 제목
    public let discountPercentage: Double  // 할인율
    public let originalPrice: Int         // 원래 가격
    public let discountedPrice: Int       // 할인된 가격

    public let maxOccupancy: Int           // 최대 인원수
    public let remainingCapacity: Int      // 참가 가능한 인원수
    public let currentParticipants: Int    // 참여하고 있는 인원 수

    public let imageURL: String

    init(
        id: String,
        title: String,
        discountPercentage: Double,
        originalPrice: Int,
        discountedPrice: Int,
        maxOccupancy: Int,
        remainingCapacity: Int,
        currentParticipants: Int,
        imageURL: String
    ) {
        self.id = id
        self.title = title
        self.discountPercentage = discountPercentage
        self.originalPrice = originalPrice
        self.discountedPrice = discountedPrice
        self.maxOccupancy = maxOccupancy
        self.remainingCapacity = remainingCapacity
        self.currentParticipants = currentParticipants
        self.imageURL = imageURL
    }
}

extension GoalContent {
    static var dummies: [GoalContent] {
           return (1...30).map { index in
               let originalPrice = [15000, 20000, 25000, 30000, 40000].randomElement() ?? 100000
               let discountPercentage = [0, 10, 15, 20, 30].randomElement() ?? 10
               let discountedPrice = originalPrice - (originalPrice * discountPercentage / 100)
               let maxOccupancy = [30, 50, 100, 150, 200].randomElement() ?? 100
               let remainingCapacity = Int.random(in: 0...maxOccupancy)

               return .init(
                   id: "\(index)",
                   title: [
                       "매일 영어 공부 30분하기",
                       "아침 6시 기상 챌린지",
                       "주 3회 운동하기",
                       "하루 물 2L 마시기",
                       "책 읽기 챌린지",
                       "임폴턴트와 함께할 수도 있고 없을 수도 있는 그런 저런 매일 영어 공부 30분하기"
                   ].randomElement() ?? "",
                   discountPercentage: Double(discountPercentage),
                   originalPrice: originalPrice,
                   discountedPrice: Int(discountedPrice),
                   maxOccupancy: maxOccupancy,
                   remainingCapacity: remainingCapacity,
                   currentParticipants: maxOccupancy - remainingCapacity,
                   imageURL: [
                    "https://picsum.photos/seed/picsum/200/300",
                    "https://picsum.photos/seed/picsum/200/300",
                    "https://picsu",
                    "https://picsum.photos/seed/picsum/200/200",
                    "https://picsum.photos/seed/picsum/200/100"
                   ].randomElement() ?? ""
               )
           }
       }
}
