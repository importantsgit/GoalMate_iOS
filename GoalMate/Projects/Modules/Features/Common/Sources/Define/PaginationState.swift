//
//  PaginationState.swift
//  FeatureCommon
//
//  Created by 이재훈 on 2/26/25.
//

import Foundation

public struct PaginationState: Equatable {
    public var totalCount: Int
    public var currentPage: Int
    public var hasMorePages: Bool
    public init(
        totalCount: Int = 0,
        currentPage: Int = 1,
        hasMorePages: Bool = true
    ) {
        self.totalCount = totalCount
        self.currentPage = currentPage
        self.hasMorePages = hasMorePages
    }
}
