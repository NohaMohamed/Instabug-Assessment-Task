//
//  FetchMoviesUseCase.swift
//  Assessment-Task
//
//  Created by Noha  on 2/16/19.
//  Copyright © 2019 Noha . All rights reserved.
//


protocol BaseUseCase {
    
    var successHandler: Success? { get set }
    func execute(success: @escaping Success)
}

class FetchMoviesUseCase: BaseUseCase {
    var successHandler: Success?
    
    func execute(success: @escaping Success) {
        successHandler = success
        let apiClient = APIClient()
        apiClient.getNewMovies(page: 1) { (movies, nil) in
            print(movies! ?? "")
        }
    }
}
