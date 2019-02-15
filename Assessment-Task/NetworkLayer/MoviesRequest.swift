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
        guard let url = URL(string: "") else { fatalError("baseURL could not be configured.")}
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
            return ["page": page]
        default:
            return nil
    }}
    
    public var headers: HTTPHeaders? {
        return nil
    }
}


