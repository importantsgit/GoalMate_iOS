//
//  NetworkClient.swift
//  Data
//
//  Created by Importants on 2/7/25.
//

import Dependencies
import Foundation
import Utils

extension NetworkService: DependencyKey {
    public static var liveValue: NetworkService {
        return NetworkService(
            config: NetworkConfiguration(
                baseURL: URL(string: Environments.baseURL)!,
                header: [
                    "Content-Type": "application/json"
                ]
            )
        )
    }
}

extension DependencyValues {
    var networkClient: NetworkService {
        get { self[NetworkService.self] }
        set { self[NetworkService.self] = newValue }
    }
}
