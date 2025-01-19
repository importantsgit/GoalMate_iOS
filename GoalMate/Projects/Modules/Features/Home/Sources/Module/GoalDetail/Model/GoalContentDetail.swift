//
//  File.swift
//  FeatureHome
//
//  Created by 이재훈 on 1/9/25.
//

import Foundation

public struct GoalContentDetail: Identifiable, Equatable {
    public let id: String
    public let details: GoalDetails
    public let discountPercentage: Int  // 할인율
    public let originalPrice: Int         // 원래 가격
    public let discountedPrice: Int       // 할인된 가격

    public let maxOccupancy: Int           // 최대 인원수
    public let remainingCapacity: Int      // 참가 가능한 인원수
    public let currentParticipants: Int    // 참여하고 있는 인원 수

    public init(
        id: String,
        details: GoalDetails,
        discountPercentage: Int,
        originalPrice: Int,
        discountedPrice: Int,
        maxOccupancy: Int,
        remainingCapacity: Int,
        currentParticipants: Int
    ) {
        self.id = id
        self.details = details
        self.discountPercentage = discountPercentage
        self.originalPrice = originalPrice
        self.discountedPrice = discountedPrice
        self.maxOccupancy = maxOccupancy
        self.remainingCapacity = remainingCapacity
        self.currentParticipants = currentParticipants
    }
}

public struct GoalDetails: Identifiable, Equatable {
    public var id: String { title }
    public let title: String
    public let goalSubject: String
    public let mentor: String
    public let period: String
    public let startDate: String
    public let endDate: String
    public let goalDescription: String
    public let weeklyGoal: [String]
    public let milestoneGoal: [String]

    public init(
        title: String,
        goalSubject: String,
        mentor: String,
        period: String,
        startDate: String,
        endDate: String,
        goalDescription: String,
        weeklyGoal: [String],
        milestoneGoal: [String]
    ) {
        self.title = title
        self.goalSubject = goalSubject
        self.mentor = mentor
        self.period = period
        self.startDate = startDate
        self.endDate = endDate
        self.goalDescription = goalDescription
        self.weeklyGoal = weeklyGoal
        self.milestoneGoal = milestoneGoal
    }
}

extension GoalContentDetail {
    static var emptyDummy: GoalContentDetail {
        let content = GoalContentDetail.dummy
        return .init(
            id: content.id,
            details: content.details,
            discountPercentage: content.currentParticipants,
            originalPrice: content.originalPrice,
            discountedPrice: content.discountedPrice,
            maxOccupancy: content.maxOccupancy,
            remainingCapacity: 0,
            currentParticipants: content.maxOccupancy
        )
    }

    static var dummy: GoalContentDetail {
        let originalPrice = [15000, 20000, 25000, 30000, 40000].randomElement() ?? 100000
        let discountPercentage = [0, 10, 15, 20, 30].randomElement() ?? 10
        let discountedPrice = originalPrice - (originalPrice * discountPercentage / 100)
        let maxOccupancy = [30, 50, 100, 150, 200].randomElement() ?? 100
        let remainingCapacity = Int.random(
            in: 0...maxOccupancy
        )
        let details = GoalDetails(
            title: "다온과 함께하는 영어 완전 정복 30일 목표",
            goalSubject: "영어",
            mentor: "다온",
            period: "30일",
            startDate: "2025년 01월 01일",
            endDate: "2025년 01월 30일",
            goalDescription: "\"백앤드 개발을 하고 싶었지만 어떤 방법으로 해야 할 지, 루틴을 세우지만 어떤 방법이 효율적일지 고민이 많지 않았나요?\"",
            weeklyGoal: [
                "간단한 코딩부터 시작하기 간단한 코딩부터 시작하기",
                "기본 문장 읽기",
                "원어민처럼 발음하는 법",
                "Hello World?"
            ],
            milestoneGoal: [
                "영어로 원어민과 편안하게 대화하는 법",
                "캐쥬얼에서 비즈니스까지 어우르는 작문법"
            ]
        )
        return GoalContentDetail(
            id: "111",
            details: details,
            discountPercentage: discountPercentage,
            originalPrice: originalPrice,
            discountedPrice: discountedPrice,
            maxOccupancy: maxOccupancy,
            remainingCapacity: remainingCapacity,
            currentParticipants: maxOccupancy - remainingCapacity
        )
    }
}
