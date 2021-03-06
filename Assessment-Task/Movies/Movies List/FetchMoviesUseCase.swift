//
//  FetchMoviesUseCase.swift
//  Assessment-Task
//
//  Created by Noha  on 2/16/19.
//  Copyright © 2019 Noha . All rights reserved.
//
import Foundation

protocol BaseUseCase {
    func execute(success: @escaping Success)
}

class FetchMoviesUseCase: BaseUseCase {
    private var isFetchInProgress = false
    private var toBeLoadedPage = 0
    
    func setPageNumber(_ page: Int) {
        self.toBeLoadedPage = page
    }
    func execute(success: @escaping Success) {
        guard !isFetchInProgress else {
            return
        }
        isFetchInProgress = true
        let movieAPIClient = MoviesAPIClient.sharedClient
        movieAPIClient.network = NetworkLayer(session: URLSession.shared)
        movieAPIClient.getNewMovies(page: toBeLoadedPage, success: { [weak self] (model) in
                self?.isFetchInProgress = false
            success(model as! MovieApiResponse)
            print(model as! MovieApiResponse)
        }) { [weak self]  (errot) in
                self?.isFetchInProgress = false
        }}
    }
