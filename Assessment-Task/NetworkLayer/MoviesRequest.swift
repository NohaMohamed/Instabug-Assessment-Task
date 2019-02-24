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
    case fetchMovieImage(_ imageURL: String)
}

extension MovieRequest: RequestData {
    
    public var baseURL: URL {
        var urlValue : String = ""
        switch self {
        case .fetchMovies:
            urlValue = "https://api.themoviedb.org/3/discover/movie/"
        case .fetchMovieImage(let imageURL):
            urlValue = "https://image.tmdb.org/t/p/w500" + imageURL
        }
        guard let url = URL(string: urlValue)  else { fatalError("baseURL could not be configured.")}
        return url
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
    
}


