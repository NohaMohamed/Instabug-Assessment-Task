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

enum Result<String>{
    case success
    case failure(String)
}

final class MoviesAPIClient {
    
    static let sharedClient = MoviesAPIClient()
    private init() {
    }
    
    let network = NetworkLayer()
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
    func getMoviemage(_ imageURL: String,success: @escaping Success, failure: @escaping Failure)  {
        let moviesRequestData = MovieRequest.fetchMovieImage(imageURL)
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
                        success(data)
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
