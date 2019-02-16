//
//  MoviesRequest.swift
//  Assessment-Task
//
//  Created by Noha  on 2/15/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

public enum MovieRequest {
    case fetchMovies(page:Int)
}

extension MovieRequest: RequestData {
    
    public var baseURL: URL {
        guard let url = URL(string: "https://api.themoviedb.org/3/discover/movie/") else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    public var path: String {
        switch self {
        case .fetchMovies(let page):
            return ""
        }
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var parameters: Parameters? {
        switch self {
        case .fetchMovies(let page):
            return ["page":page,
                    "api_key":"acea91d2bff1c53e6604e4985b6989e2"]
        default:
            return nil
    }}
    
    public var headers: HTTPHeaders? {
        return nil
    }
}


