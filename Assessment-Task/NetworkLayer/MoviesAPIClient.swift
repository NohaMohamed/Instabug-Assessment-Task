//
//  MoviesAPIClient.swift
//  Assessment-Task
//
//  Created by Noha  on 2/16/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import Foundation

typealias Success = (Decodable) -> Void
typealias Failure = (Error?) -> Void
typealias SuccessDownload = (Data) -> Void

enum Result<String>{
    case success
    case failure(String)
}

final class MoviesAPIClient {
    
    static let sharedClient = MoviesAPIClient()
    var session: URLSessionProtocol?
    let cache = NSCache<AnyObject, AnyObject>()
    private init() {}
    lazy var network = NetworkLayer(session: session ?? MockURLSession())
    
    func getNewMovies(page: Int, success: @escaping Success, failure: @escaping Failure){
        let moviesRequestData = MovieRequest.fetchMovies(page: page)
        network.request(moviesRequestData) { data, response, error in
            
            if error != nil {
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        //                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        print(responseData)
                        let jsonData = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers)
                        print(jsonData)
                        let apiResponse = try JSONDecoder().decode(MovieApiResponse.self, from: responseData)
                        success(apiResponse)
                    }catch {
                        print(error)
                        //                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    failure(networkFailureError as! Error)
                }
            }
        }
    }
    func getMoviemage(_ imageURL: String,success: @escaping SuccessDownload, failure: @escaping Failure)  {
        let moviesRequestData = MovieRequest.fetchMovieImage(imageURL)
        network.downloadRequest(moviesRequestData) { data, response, error in
            
            if error != nil {
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        //                        completion(nil, NetworkResponse.noData.rawValue)
                        return
                    }
                    do {
                        success(responseData)
                    }catch {
                        print(error)
                        //                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    failure(networkFailureError as! Error)
                }
            }
        }
    }
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        switch response.statusCode {
        case 200...299: return .success
        default: return .success
        }
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
class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    private (set) var lastURL: URL?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask {
        self.lastURL = request.url
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return  URLSessionDataTask()
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
typealias DataTaskResult = (Data?, URLResponse?, Error?) -> ()
