//
//  Version.swift
//  Data
//
//  Created by 이재훈 on 2/19/25.
//

import Foundation

struct Version: Comparable {
    let major: Int
    let minor: Int
    let patch: Int
    init(from string: String) {
        let components = string.split(separator: ".").map { Int($0) ?? 0 }
        self.major = components.isEmpty == false ? components[0] : 0
        self.minor = components.count > 1 ? components[1] : 0
        self.patch = components.count > 2 ? components[2] : 0
    }
    static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major { return lhs.major < rhs.major }
        if lhs.minor != rhs.minor { return lhs.minor < rhs.minor }
        return lhs.patch < rhs.patch
    }
}

public enum UpdateStatus: Equatable {
    case none
    case update(UpdateType)
    public enum UpdateType {
        case major // 필수 없데이트
        case minor // 선택적 업데이트
    }
}

struct AppStoreResponse: Decodable {
    let results: [AppInfo]
    struct AppInfo: Decodable {
        let version: String
    }
}
