//
//  MyGoalContent.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import Data
import Foundation

public struct MyGoalContent: Identifiable, Equatable {
    public enum MenteeGoalStatus {
        case inProgress
        case completed
        case failed
        case canceled
    }
    public let id: Int
    /**
      목표의 제목
      */
    let title: String
    /**
     목표의 진척율
     - Important: 10 단위로만 입력 가능 (0, 10, 20, ..., 100)
     */
    let progress: CGFloat
    /**
     목표 시작일
     */
    let startDate: String
    /**
     목표 마감일
     */
    let endDate: String

    let mainImageURL: String

    let goalStatus: MenteeGoalStatus

    init(
        id: Int,
        title: String?,
        progress: CGFloat,
        startDate: String?,
        endDate: String?,
        mainImageURL: String?,
        goalStatus: FetchMyGoalsResponseDTO
            .Response
            .MenteeGoal
            .MenteeGoalStatus
    ) {
        self.id = id
        self.title = title ?? ""
        self.progress = progress
        self.startDate = startDate?.convertDate() ?? ""
        self.endDate = endDate?.convertDate() ?? ""
        self.mainImageURL = mainImageURL ?? ""
        let value: MenteeGoalStatus
        switch goalStatus {
        case .inProgress: value = .inProgress
        case .completed: value = .completed
        case .failed: value = .failed
        case .canceled: value = .canceled
        }
        self.goalStatus = value
    }
}

fileprivate extension String {
    func convertDate() -> String? {
        let date = self.split(separator: "-").map { String($0) }
        guard date.count == 3 else { return nil }
        return "\(date[0])년 \(date[1])월 \(date[2])일"
    }
}

extension MyGoalContent {
    static let dummies: [MyGoalContent] = [
        MyGoalContent(
            id: 1,
            title: "1일 1커밋 습관 만들기",
            progress: 80,
            startDate: "2025-01-01",
            endDate: "2025-12-31",
            mainImageURL: "https://example.com/git-image.jpg",
            goalStatus: .inProgress
        ),
        MyGoalContent(
            id: 2,
            title: "Swift 문법 마스터하기",
            progress: 100,
            startDate: "2025-01-15",
            endDate: "2025-02-28",
            mainImageURL: "https://example.com/swift-image.jpg",
            goalStatus: .completed
        ),
        MyGoalContent(
            id: 3,
            title: "오픈소스 프로젝트 기여하기",
            progress: 30,
            startDate: "2025-02-01",
            endDate: "2025-04-30",
            mainImageURL: "https://example.com/opensource-image.jpg",
            goalStatus: .inProgress
        ),
        MyGoalContent(
            id: 4,
            title: "알고리즘 문제 50개 풀기",
            progress: 0,
            startDate: "2025-02-15",
            endDate: "2025-03-15",
            mainImageURL: "https://example.com/algorithm-image.jpg",
            goalStatus: .failed
        ),
        MyGoalContent(
            id: 5,
            title: "iOS 앱 출시하기",
            progress: 60,
            startDate: "2025-01-10",
            endDate: "2025-06-30",
            mainImageURL: "https://example.com/ios-image.jpg",
            goalStatus: .canceled
        ),
        MyGoalContent(
            id: 6,
            title: "TDD 연습하기",
            progress: 40,
            startDate: "2025-02-10",
            endDate: "2025-05-10",
            mainImageURL: "https://example.com/tdd-image.jpg",
            goalStatus: .inProgress
        )
    ]
}
