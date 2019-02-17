//
//  MoviesListPresenter.swift
//  Assessment-Task
//
//  Created by Noha  on 2/15/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit
protocol MoviesListPresenter {
    func viewWillAppear()
    func moviesCount() -> Int
    
}

protocol MoviesListPresenterView: class {
    func showLoading()
    func hideLoading()
    func configureMovies(_ movies: [Movie])
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
}
class MoviesListPresenterImplementation : MoviesListPresenter {
    
    //MARK-: Properties
    
    fileprivate weak var view: MoviesListPresenterView?
    private var fetchMoviesUseCase: FetchMoviesUseCase
    private var router: MoviesListRouter?
    private var movies: [Movie] = []
    private var currentPage = 1
    
    func viewWillAppear() {
        
        fetchMoviesUseCase.setPageNumber(currentPage)
        fetchMoviesUseCase.execute { movieApiResponse in
            DispatchQueue.main.async {
                let moviesResponse = movieApiResponse as! MovieApiResponse
                let allMovies = moviesResponse.movies
                self.currentPage += 1
                self.movies += allMovies
                self.view?.configureMovies(allMovies)
                if moviesResponse.page > 1 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: self.movies)
                    self.view?.onFetchCompleted(with: indexPathsToReload)
                } else {
                    //                self.delegate?.onFetchCompleted(with: .none)
                }
            }
        }
    }
    init(view: MoviesListPresenterView,
         fetchMoviesUseCase: FetchMoviesUseCase,
         router: MoviesListRouter) {
        self.view = view
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.router = router
    }
    func moviesCount() -> Int {
        return movies.count
    }
    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = movies.count - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
