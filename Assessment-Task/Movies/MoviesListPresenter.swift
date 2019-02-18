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
    func fun(url: String, indexPath: IndexPath)
    func mapMovieDetailsUIMode(_ movie: Movie) ->  MovieDetailViewModel
    func totalCount() -> Int
}

protocol MoviesListPresenterView: class {
    func showLoading()
    func hideLoading()
    func configureMovies(_ movies: [Movie])
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func retu(image: UIImage,indexpath: IndexPath)
}
class MoviesListPresenterImplementation : MoviesListPresenter {
    
    //MARK-: Properties
    
    fileprivate weak var view: MoviesListPresenterView?
    private var fetchMoviesUseCase: FetchMoviesUseCase
    private var router: MoviesListNavigator?
    private var movies: [Movie] = []
    private var currentPage = 1
    private var totalMoviesResult = 0
    
    func viewWillAppear() {
        
        fetchMoviesUseCase.setPageNumber(currentPage)
        fetchMoviesUseCase.execute { movieApiResponse in
            DispatchQueue.main.async {
                let moviesResponse = movieApiResponse as! MovieApiResponse
                let allMovies = moviesResponse.movies
                self.totalMoviesResult = moviesResponse.numberOfResults
                self.currentPage += 1
                self.movies += allMovies
                
                if moviesResponse.page > 1 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: self.movies)
                    self.view?.onFetchCompleted(with: indexPathsToReload)
                } else {
                    //                self.delegate?.onFetchCompleted(with: .none)
                }
                self.view?.configureMovies(self.movies)
                self.view?.hideLoading()
            }
        }
    }
    init(view: MoviesListPresenterView,
         fetchMoviesUseCase: FetchMoviesUseCase,
         router: MoviesListNavigator) {
        self.view = view
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.router = router
    }
    func moviesCount() -> Int {
        return movies.count
    }
    func totalCount() -> Int {
        return totalMoviesResult
    }
    func mapMovieDetailsUIMode(_ movie: Movie) ->  MovieDetailViewModel {
       var movieDetailViewModel = MovieDetailViewModel()
        movieDetailViewModel.title = movie.title
        movieDetailViewModel.overview = movie.overview
        movieDetailViewModel.releaseDate = movie.releaseDate
        movieDetailViewModel.movieDetailsCardStatus = .view
        return movieDetailViewModel
    }
    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = movies.count - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    func fun(url: String, indexPath: IndexPath) {
        let imageCache = MoviesAPIClient.sharedClient.cache
        if (imageCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil) {
            let image = imageCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            view?.retu(image: image!, indexpath: indexPath)
        }else{
            MoviesAPIClient.sharedClient.getMoviemage(url, success: { response in
                DispatchQueue.main.async {
                    let image = UIImage(data: response)
                    self.view?.retu(image: image!, indexpath: indexPath)
                }
            }) { (error) in
                print("la2aaa")
            }
        }
    }
}
