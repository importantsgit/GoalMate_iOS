//
//  CommentRoomCell.swift
//  FeatureComment
//
//  Created by 이재훈 on 2/28/25.
//

import Data
import Foundation
import Utils

public struct CommentRoomCell: Identifiable, Equatable {
    public var id: Int { roomInfo.id }
    public let roomInfo: CommentRoom
    public let isExpired: Bool
    public let dDay: String
    init(
        roomInfo: CommentRoom
    ) {
        let endDate = roomInfo.endDate ?? ""
        self.roomInfo = roomInfo
        self.isExpired = CommentRoomCell.getExpiredStatus(
            fromDate: endDate
        )
        self.dDay = Date().toString()
            .calculateDday(
                endDate: endDate
            )
    }

    private static func getExpiredStatus(fromDate: String?) -> Bool {
        guard let fromDate else { return false }
        let date = fromDate.toDate(format: "yyyy-MM-dd")
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: Date())
        let endDate = calendar.startOfDay(for: date)
        return currentDate > endDate
    }
}
