//
//  Extension+String.swift
//  Utils
//
//  Created by Importants on 1/16/25.
//

import Foundation

public extension String {
    func splitCharacters() -> String {
        self.split(separator: "").joined(separator: "\u{200B}")
    }

    func convertDateString(
        fromFormat: String = "yyyy-MM-dd",
        toFormat: String = "yyyy년 M월 dd일"
    ) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat
        formatter.timeZone = TimeZone.current  // 현재 시간대 사용
        formatter.calendar = Calendar.current
        guard let date = formatter.date(from: self)
        else { return nil }
        formatter.dateFormat = toFormat
        return formatter.string(from: date)
    }

    func toDate(format: String = "yyyy-MM-dd") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current  // 현재 시간대 사용
        formatter.calendar = Calendar.current
        return formatter.date(from: self) ?? Date()
    }

    func calculateDday(endDate: String) -> String {
        let calendar = Calendar.current
        let currentDate = calendar.startOfDay(for: self.toDate())
        let endDateObj = endDate.toDate(format: "yyyy-MM-dd")
        let components = calendar.dateComponents([.day], from: currentDate, to: endDateObj)
        let days = components.day ?? 0
        return "D-\(days)"  // 숫자만 반환
    }
    
    func parseAndDisplayDate() -> String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        guard let date = isoFormatter.date(from: self) else {
            return "날짜 오류"
        }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy-MM-dd"
        displayFormatter.locale = Locale(identifier: "ko_KR")
        displayFormatter.timeZone = TimeZone.current
        return displayFormatter.string(from: date)
    }
}
