//
//  DataStorageClient.swift
//  Data
//
//  Created by Importants on 2/7/25.
//

import Dependencies
import Foundation
import Utils

extension DataStorageService: DependencyKey {
    public static var liveValue: DataStorageService {
        return DataStorageService()
    }
}

extension DependencyValues {
    var dataStorageClient: DataStorageService {
        get { self[DataStorageService.self] }
        set { self[DataStorageService.self] = newValue }
    }
}
