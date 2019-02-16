//
//  APIClient.swift
//  Assessment-Task
//
//  Created by Noha  on 2/15/19.
//  Copyright © 2019 Noha . All rights reserved.
//
import Foundation

typealias Success = () -> Void
typealias Failure = (Error?) -> Void

enum Result<String>{
    case success
    case failure(String)
}

struct APIClient {
    let network = NetworkLayer()
    func getNewMovies(page: Int, completion: @escaping (_ movie: [Movie]?,_ error: String?)->()){
        let moviesRequestData = MovieRequest.fetchMovies(page: page)
        network.request(moviesRequestData) { data, response, error in
            
            if error != nil {
                completion(nil, "Please check your network connection.")
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
                        completion(apiResponse.movies,nil)
                    }catch {
                        print(error)
//                        completion(nil, NetworkResponse.unableToDecode.rawValue)
                    }
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError)
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
