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
    func fun(indexPath: IndexPath)
    func mapMovieDetailsUIMode(_ movie: Movie) ->  MovieDetailViewModel
    func totalCount() -> Int
    func getMovie(at index: IndexPath) -> MovieDetailViewModel
    func navigateToMovieDetailViewController()
    func titleOfSection(_ section: Int) -> String
    func numberOfSections() -> Int
    func addNewMovie(_ movie: Movie)
    func numberOfRows(_ section: Int) -> Int
}

protocol MoviesListPresenterView: class {
    func showLoading()
    func hideLoading()
    func reloadData()
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func retu(image: UIImage,indexpath: IndexPath)
}
class MoviesListPresenterImplementation : MoviesListPresenter {
    
    //MARK-: Properties
    
    fileprivate weak var view: MoviesListPresenterView?
    private var fetchMoviesUseCase: FetchMoviesUseCase
    private var router: MoviesListNavigator?
    private var currentPage = 1
    fileprivate var totalMoviesResult = 0
    var moviesListTableViewSections: [MoviesListTableViewSection] = []
//    lazy fileprivate var movies: [Movie]? = moviesListTableViewSections.first(where: {$0.sectionType == .allMovies})?.movies
    
    //MARK -: Intialization
    
    init(view: MoviesListPresenterView,
         fetchMoviesUseCase: FetchMoviesUseCase,
         router: MoviesListNavigator) {
        self.view = view
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.router = router
    }
    func viewWillAppear() {
        fetchAvailableMovies()
    }
    
    //MARK: - Calling API
    private func fetchAvailableMovies() {
        fetchMoviesUseCase.setPageNumber(currentPage)
        fetchMoviesUseCase.execute { movieApiResponse in
            DispatchQueue.main.async {
                let moviesResponse = movieApiResponse as! MovieApiResponse
                let allMovies = moviesResponse.movies
                self.totalMoviesResult = moviesResponse.numberOfResults
                self.currentPage += 1
                if let index = self.moviesListTableViewSections.index(where: {$0.sectionType == .allMovies}) {
                    self.moviesListTableViewSections[index].movies += allMovies
                }else{
                    let newSection = MoviesListTableViewSection(sectionType: .allMovies,movies: allMovies)
                    self.moviesListTableViewSections.append(newSection)
                }
                if moviesResponse.page > 1 {
                    let indexPathsToReload = self.calculateIndexPathsToReload(from: allMovies)
                    self.view?.onFetchCompleted(with: indexPathsToReload)
                } else {
                    self.view?.onFetchCompleted(with: .none)
                }
                self.view?.hideLoading()
            }
        }
    }
    func fun(indexPath: IndexPath) {
        let imageCache = MoviesAPIClient.sharedClient.cache
        if (imageCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil) {
            let image = imageCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            view?.retu(image: image!, indexpath: indexPath)
        }else{
            guard let url = getImageURL(indexPath: indexPath) else{
                return
            }
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
    private func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = getAllMovies()!.count - newMovies.count
        let endIndex = startIndex + newMovies.count
        if getMyMovies() != nil{
            return (startIndex..<endIndex).map { IndexPath(row: $0, section: 1) }
        }
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    func getImageURL(indexPath: IndexPath) -> String? {
        guard let movies = getAllMovies() else {
            return nil
        }
        let url = movies[indexPath.row].posterPath
        return url
    }
    private func getAllMovies() -> [Movie]? {
        return moviesListTableViewSections.first(where: {$0.sectionType == .allMovies})?.movies ?? nil
    }
    private func getMyMovies() -> [Movie]? {
        return moviesListTableViewSections.first(where: {$0.sectionType == .myMovies})?.movies ?? nil
    }
    //MARK:- UI Handling
    
    func getMovie(at index: IndexPath) -> MovieDetailViewModel {
        let movies = moviesListTableViewSections[index.section].movies
        let movieDetails = mapMovieDetailsUIMode(movies[index.row])
        return movieDetails
    }
    func mapMovieDetailsUIMode(_ movie: Movie) ->  MovieDetailViewModel {
       var movieDetailViewModel = MovieDetailViewModel()
        movieDetailViewModel.title = movie.title
        movieDetailViewModel.overview = movie.overview
        movieDetailViewModel.releaseDate = movie.releaseDate
        movieDetailViewModel.movieDetailsCardStatus = .view
        return movieDetailViewModel
    }
    func addNewMovie(_ movie: Movie) {
        if let index = self.moviesListTableViewSections.index(where: {$0.sectionType == .myMovies}) {
            self.moviesListTableViewSections[index].movies.append(movie)
        }else{
            let newSection = MoviesListTableViewSection(sectionType: .myMovies,movies: [movie])
            self.moviesListTableViewSections.append(newSection)
            self.moviesListTableViewSections.reverse()
            
        }
        view?.reloadData()
    } 
    func navigateToMovieDetailViewController() {
        router?.navigate(to: .addMovieDetails)
    }
}
// MARK: - Handle TableView
extension MoviesListPresenterImplementation {
    func moviesCount() -> Int {
        return getAllMovies()!.count
    }
    func totalCount() -> Int {
        return totalMoviesResult
    }
    func numberOfSections() -> Int {
        return  moviesListTableViewSections.count
    }
    func titleOfSection(_ section: Int) -> String {
        return moviesListTableViewSections[section].sectionTitle
    }
    func numberOfRows(_ section: Int) -> Int {
        if moviesListTableViewSections[section].sectionType == .allMovies {
            return totalCount()
        }
        return moviesListTableViewSections[section].movies.count
    }
}
