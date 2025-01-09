//
//  Extension+CGFloat.swift
//  Utils
//
//  Created by 이재훈 on 1/9/25.
//

import CoreGraphics

extension CGFloat {
  public static func grid(_ value: Int) -> Self { Self(value) * 4 }
}
