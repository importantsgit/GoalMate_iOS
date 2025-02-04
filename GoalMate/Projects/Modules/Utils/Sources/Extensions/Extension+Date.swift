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
        return formatter.string(from: self)
    }

    func getString() -> String {
        formatted("yyyy년 MM월 dd일")
    }
}
