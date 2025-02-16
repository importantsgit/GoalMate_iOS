//
//  EndPoint.swift
//  Data
//
//  Created by Importants on 2/5/25.
//

import Foundation

struct Endpoint<R>: ResponseRequestable {
    typealias Response = R

    let path: String
    let method: HTTPMethodType
    let headerParameters: [String: String]
    let queryParametersEncodable: Encodable?
    let queryParameters: [String: Any]
    let bodyParametersEncodable: Encodable?
    let bodyParameters: [String: Any]
    let bodyEncoder: BodyEncoder
    let responseDecoder: ResponseDecoder

    init(
        path: APIEndpoints.APIPath,
        method: HTTPMethodType,
        headerParameters: [String: String] = [:],
        queryParametersEncodable: Encodable? = nil,
        queryParameters: [String: Any] = [:],
        bodyParametersEncodable: Encodable? = nil,
        bodyParameters: [String: Any] = [:],
        bodyEncoder: BodyEncoder = JSONBodyEncoder(),
        responseDecoder: ResponseDecoder = JSONResponseDecoder()
    ) {
        self.path = path.rawValue
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyEncoder = bodyEncoder
        self.responseDecoder = responseDecoder
    }
}

// Path Parameter init
extension Endpoint {
    init(
        path: APIEndpoints.APIPath,
        pathParameters: [String: String],
        method: HTTPMethodType,
        headerParameters: [String: String] = [:],
        queryParametersEncodable: Encodable? = nil,
        queryParameters: [String: Any] = [:],
        bodyParametersEncodable: Encodable? = nil,
        bodyParameters: [String: Any] = [:]
    ) throws {
        self.path = path.path(with: pathParameters)
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyEncoder = JSONBodyEncoder()
        self.responseDecoder = JSONResponseDecoder()
    }
}

// MARK: - HTTPMethodType
enum HTTPMethodType: String {
    case delete = "DELETE"
    case get = "GET"
    case patch = "PATCH"
    case post = "POST"
    case put = "PUT"
}

// MARK: - Requestable
protocol Requestable {
    var path: String { get }
    var method: HTTPMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    var bodyEncoder: BodyEncoder { get }

    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest
}

extension Requestable {
    func url(
        with config: NetworkConfigurable
    ) throws -> URL {
        var baseURL = config.baseURL.absoluteString
        baseURL = baseURL.suffix(1) == "/" ? baseURL : baseURL + "/"
        let endpoint = baseURL.appending(path)

        guard var urlComponent = URLComponents(
            string: endpoint
        ) else { throw NetworkError.URLError }

        var urlQueryItems = [URLQueryItem]()
        let queryParameters = queryParametersEncodable?.toDictionary ?? self.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }

        urlComponent.queryItems = urlQueryItems.isEmpty == false
        ? urlQueryItems
        : nil
        guard let url = urlComponent.url else { throw NetworkError.URLError }

        return url
    }

    func urlRequest(
        with config: NetworkConfigurable
    ) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var header = config.header
        headerParameters.forEach { header.updateValue($1, forKey: $0) }

        let bodyParameters = bodyParametersEncodable?.toDictionary ?? self.bodyParameters
        if bodyParameters.isEmpty == false {
            urlRequest.httpBody = bodyEncoder.encode(bodyParameters)
        }

        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = header

        return urlRequest
    }
}

protocol ResponseRequestable: Requestable {
    associatedtype Response

    var responseDecoder: ResponseDecoder { get }
}

fileprivate extension Encodable {
    var toDictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments)
        ).flatMap { $0 as? [String: Any] }
    }
}
