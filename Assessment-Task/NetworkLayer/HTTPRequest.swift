//
//  HTTPRequest.swift
//  Assessment-Task
//
//  Created by Noha  on 2/15/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import Foundation

// MARK: -

/// A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String:String]

public protocol ParameterEncoder {
    func encode( _  urlRequest: inout URLRequest, with parameters: Parameters) throws
}

public enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case delete  = "DELETE"
}

public protocol RequestData {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
}

public struct ParameterEncoding: ParameterEncoder {
    public func encode(_ urlRequest: inout URLRequest, with parameters: Parameters) throws {
//                guard let url = urlRequest.url else {  }
        if var urlComponents = URLComponents(url: urlRequest.url! ,
                                                        resolvingAgainstBaseURL: false), !parameters.isEmpty {
                    urlComponents.queryItems = [URLQueryItem]()
            let queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)) }
            urlComponents.queryItems = queryItems
            urlRequest.url = urlComponents.url
        }
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
