//
//  MockSessionURL.swift
//  Assessment-Task
//
//  Created by Noha  on 2/23/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

class MockURLSession: URLSessionProtocol {
    
    var mockDataTask = MockURLSessionDataTask()
    var data: Data?
    var networkError: Error?
    private (set) var lastURL: URL?
    
    init(data:Data? = nil, networkError:Error? = nil) {
        self.data = data
        self.networkError = networkError
    }
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTaskProtocol {
        self.lastURL = request.url
        completionHandler(data, successHttpURLResponse(request: request), networkError)
        return  mockDataTask
    }
}
class MockTask: URLSessionDataTask {
    private let data: Data?
    private let urlResponse: URLResponse?
    private let networkError: Error?
    
    var completionHandler: NetworkCompletion?
    init(data: Data?, urlResponse: URLResponse?, networkError: Error?) {
        self.data = data
        self.urlResponse = urlResponse
        self.networkError = networkError
    }
    override func resume() {
        DispatchQueue.main.async {
            self.completionHandler!(self.data, self.urlResponse, self.networkError)
        }
    }
}
class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}
extension URLSessionDataTask: URLSessionDataTaskProtocol {}
protocol URLSessionDataTaskProtocol {
    func resume()
}
