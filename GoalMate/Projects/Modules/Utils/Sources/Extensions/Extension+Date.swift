//
//  Extension+Date.swift
//  Utils
//
//  Created by Importants on 1/22/25.
//

import Foundation

public extension Date {
    func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current  // 현재 시간대 사용
        formatter.calendar = Calendar.current
        return formatter.string(from: self)
    }

    func getString(format: String = "yyyy년 MM월 dd일") -> String {
        formatted(format)
    }
}
