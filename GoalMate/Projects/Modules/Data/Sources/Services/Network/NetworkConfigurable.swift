//
//  NetworkConfigurable.swift
//  Data
//
//  Created by Importants on 2/5/25.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get set }
    var header: [String: String] { get }
    var queryParameters: [String: Any] { get }
}

struct NetworkConfiguration: NetworkConfigurable {
    var baseURL: URL
    let header: [String: String]
    let queryParameters: [String: Any]

    init(
        baseURL: URL,
        header: [String: String] = [:],
        queryParameters: [String: Any] = [:]
    ) {
        self.baseURL = baseURL
        self.header = header
        self.queryParameters = queryParameters
    }
}
