//
//  Decoder.swift
//  Data
//
//  Created by Importants on 2/5/25.
//

import Foundation

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()

    func decode<T>(
        _ data: Data
    ) throws -> T where T: Decodable {
        try jsonDecoder.decode(T.self, from: data)
    }
}
