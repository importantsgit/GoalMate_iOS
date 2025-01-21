//
//  MyGoalContent.swift
//  FeatureMyGoal
//
//  Created by 이재훈 on 1/21/25.
//

import Foundation

/**
목표 정보를 담는 모델

사용자의 목표 정보를 관리하는 구조체입니다.
목표의 제목, 상태, 진척율, 시작일, 마감일 등의 정보를 포함합니다.

진척율은 10단위로 표시되며(0, 10, 20, ..., 100),
isExpired를 통해 목표의 만료 여부를 확인할 수 있습니다.

```swift
let goal = MyGoalContent(
    title: "운동하기",
    state: .inProgress,
    progress: 30,
    startDate: Date(),
    endDate: Date().addingTimeInterval(86400 * 30)
)
```
*/
public struct MyGoalContent: Identifiable {
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
    let startDate: Date
    /**
     목표 마감일
     */
    let endDate: Date
    /**
     목표의 기간 만료 여부
     
     시간은 무시하고 날짜만 비교
     마감일 당일까지는 false, 다음날부터 true 반환
     */
    var isExpired: Bool {
        let calendar = Calendar.current
        let today = calendar.dateComponents([.year, .month, .day], from: Date())
        let end = calendar.dateComponents([.year, .month, .day], from: endDate)
        guard let todayDate = calendar.date(from: today),
              let endDate = calendar.date(from: end)
        else { return false }
        return todayDate > endDate
    }

    init(
        id: Int,
        title: String,
        progress: CGFloat,
        startDate: Date,
        endDate: Date
    ) {
        self.id = id
        self.title = title
        self.progress = progress
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension MyGoalContent {
    static let dummies: [MyGoalContent] = [
        // 현재 진행 중인 목표들
        MyGoalContent(
            id: 1,
            title: "매일 30분 운동하기",
            progress: 0,
            startDate: Date(),
            endDate: Date().addingTimeInterval(86400 * 30)
        ),
        MyGoalContent(
            id: 2,
            title: "책 10권 읽기",
            progress: 50,
            startDate: Date().addingTimeInterval(-86400 * 15),
            endDate: Date().addingTimeInterval(86400 * 15)
        ),
        MyGoalContent(
            id: 3,
            title: "프로그래밍 공부",
            progress: 90,
            startDate: Date().addingTimeInterval(-86400 * 25),
            endDate: Date().addingTimeInterval(86400 * 5)
        ),
        // 완료된 목표들
        MyGoalContent(
            id: 4,
            title: "건강한 식단 관리",
            progress: 100,
            startDate: Date().addingTimeInterval(-86400 * 60),
            endDate: Date().addingTimeInterval(-86400 * 30)
        ),
        MyGoalContent(
            id: 5,
            title: "아침 명상하기",
            progress: 100,
            startDate: Date().addingTimeInterval(-86400 * 45),
            endDate: Date().addingTimeInterval(-86400 * 15)
        ),
        // 만료된 목표들
        MyGoalContent(
            id: 6,
            title: "블로그 작성하기",
            progress: 60,
            startDate: Date().addingTimeInterval(-86400 * 40),
            endDate: Date().addingTimeInterval(-86400 * 10)
        ),
        MyGoalContent(
            id: 7,
            title: "새 언어 배우기",
            progress: 30,
            startDate: Date().addingTimeInterval(-86400 * 30),
            endDate: Date().addingTimeInterval(-86400 * 5)
        )
    ]

    // 필터링된 더미 데이터 가져오기
    static var activeDummyData: [MyGoalContent] {
        dummies.filter { !$0.isExpired && $0.progress < 100 }
    }

    static var completedDummyData: [MyGoalContent] {
        dummies.filter { $0.progress == 100 }
    }

    static var expiredDummyData: [MyGoalContent] {
        dummies.filter { $0.isExpired && $0.progress < 100 }
    }
}
