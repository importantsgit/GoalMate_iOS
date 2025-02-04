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
}
