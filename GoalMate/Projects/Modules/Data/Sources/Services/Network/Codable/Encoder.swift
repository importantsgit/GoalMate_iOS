//
//  Encoder.swift
//  Data
//
//  Created by Importants on 2/5/25.
//

import Foundation

// MARK: - BodyEncoder
protocol BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data?
}

struct JSONBodyEncoder: BodyEncoder {
    func encode(_ parameters: [String: Any]) -> Data? {
        var data = Data()
        return try? JSONSerialization.data(withJSONObject: parameters)
    }
}

struct MultipartFormDataEncoder: BodyEncoder {
    let boundary: String

    init(boundary: String = UUID().uuidString) {
        self.boundary = boundary
    }

    func encode(_ parameters: [String: Any]) -> Data? {
        var data = Data()
        // 일반 파라미터 처리
        if let dict = parameters["parameters"] as? [String: Any] {
            dict.forEach { key, value in
                data.append(createFormField(named: key, value: value))
            }
        }
        // 파일 데이터 처리
        if let fileDict = parameters["files"] as? [String: (Data, String, String)] {
            fileDict.forEach { key, fileInfo in
                let (fileData, fileName, mimeType) = fileInfo
                data.append(
                    createFileField(
                        named: key,
                        filename: fileName,
                        mimeType: mimeType,
                        fileData: fileData
                    )
                )
            }
        }
        if let appendData = "--\(boundary)--\r\n".data(using: .utf8) {
            data.append(appendData)
        }
        return data
    }
    private func createFormField(named name: String, value: Any) -> Data {
        var fieldData = Data()
        if let data = "--\(boundary)\r\n"
            .data(using: .utf8) {
            fieldData.append(data)
        }
        if let data = """
        Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n
        """
            .data(using: .utf8) {
            fieldData.append(data)
        }
        if let data = "\(value)\r\n".data(using: .utf8) {
            fieldData.append(data)
        }
        return fieldData
    }

    private func createFileField(
        named name: String,
        filename: String,
        mimeType: String,
        fileData: Data
    ) -> Data {
        var fieldData = Data()

        if let boundaryData = "--\(boundary)\r\n".data(using: .utf8) {
            fieldData.append(boundaryData)
        }

        if let dispositionData = """
        Content-Disposition: form-data; name="\(name)"; filename="\(filename)"\r\n
        """.data(using: .utf8) {
            fieldData.append(dispositionData)
        }

        if let contentTypeData = "Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8) {
            fieldData.append(contentTypeData)
        }

        fieldData.append(fileData)

        if let lineBreakData = "\r\n".data(using: .utf8) {
            fieldData.append(lineBreakData)
        }
        return fieldData
    }
}
