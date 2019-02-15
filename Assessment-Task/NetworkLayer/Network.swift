//
//  requestDatar.swift
//  Assessment-Task
//
//  Created by Noha  on 2/15/19.
//  Copyright © 2019 Noha . All rights reserved.
//


import Foundation

public typealias NetworkCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?)->()

protocol Network: class {
//    associatedtype request: Request
    func request(_ requestData: RequestData, completion: @escaping NetworkCompletion)
    func cancel()
}

class NetworkLayer<request: RequestData>: Network {
    private var task: URLSessionTask?
    
    func request(_ requestData: RequestData, completion: @escaping NetworkCompletion) {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: requestData)
//            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from requestData: RequestData) throws -> URLRequest {
        
        var request = URLRequest(url: requestData.baseURL.appendingPathComponent(requestData.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        
//        request.httpMethod = requestData.httpMethod.rawValue
        do {
            if let requestDataParameters = requestData.parameters  {
                try self.configureParameters(urlParameters: requestDataParameters, request: &request)
            }else {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(urlParameters: Parameters, request: inout URLRequest) throws {
        let parametersEncoder = ParameterEncoding()
        do {
            try parametersEncoder.encode(&request, with: urlParameters)
        } catch {
            throw error
        }
    }
    
}
