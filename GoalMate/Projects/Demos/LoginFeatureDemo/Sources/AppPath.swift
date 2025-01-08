//
//  AppPath.swift
//  DemoLoginFeature
//
//  Created by 이재훈 on 1/8/25.
//

import Foundation
import Login
import Sharing

enum AppPath: Codable, Hashable {
  case login

  // NB: Encode only certain paths for state restoration.
  var isRestorable: Bool {
    switch self {
    case .login: true
    }
  }
}

extension SharedReaderKey where Self == FileStorageKey<[AppPath]>.Default {
  static var path: Self {
    Self[
      .fileStorage(
        .documentsDirectory.appending(path: "path.json"),
        decode: { data in
          try JSONDecoder().decode([AppPath].self, from: data)
        },
        encode: { path in
          try JSONEncoder().encode(path.filter(\.isRestorable))
        }
      ),
      default: []
    ]
  }
}
