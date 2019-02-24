//
//  MoviesListPresenter.swift
//  Assessment-Task
//
//  Created by Noha  on 2/15/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit
protocol MoviesListPresenter {
    func fetchAvailableMovies()
    func moviesCount() -> Int
    func downloadMovieImage(_ indexPath: IndexPath)
    func mapMovieDetailsUIModel(_ movie: Movie) ->  MovieDetailViewModel
    func totalCount() -> Int
    func getMovie(at index: IndexPath) -> MovieDetailViewModel
    func navigateToMovieDetailViewController(_ newMovieDetails: @escaping addMovieDetailsAction)
    func titleOfSection(_ section: Int) -> String
    func numberOfSections() -> Int
    func addNewMovie(_ movie: MovieDetailViewModel)
    func numberOfRows(_ section: Int) -> Int
}

protocol MoviesListPresenterView: class {
    func showLoading()
    func hideLoading()
    func reloadData()
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func displayMovieImage(image: UIImage,indexpath: IndexPath)
}
class MoviesListPresenterImplementation : MoviesListPresenter {
    
    //MARK-: Properties
    
    fileprivate weak var view: MoviesListPresenterView?
    private var fetchMoviesUseCase: FetchMoviesUseCase
    private var router: MoviesListNavigator?
    private var currentPage = 1
    fileprivate var totalMoviesResult = 0
    private var addedImages: [UIImage] = []
    var moviesListTableViewSections: [MoviesListTableViewSection] = []
    
    //MARK -: Intialization
    
    init(view: MoviesListPresenterView,
         fetchMoviesUseCase: FetchMoviesUseCase,
         router: MoviesListNavigator) {
        self.view = view
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.router = router
    }
    
    //MARK: - Calling API
    
     func fetchAvailableMovies() {
        fetchMoviesUseCase.setPageNumber(currentPage)
        fetchMoviesUseCase.execute { movieApiResponse in
            DispatchQueue.main.async {
                let moviesResponse = movieApiResponse as! MovieApiResponse
                let allMovies = moviesResponse.movies
                var allUIModel = [MovieDetailViewModel]()
                self.totalMoviesResult = moviesResponse.numberOfResults
                self.currentPage += 1
                for movie in allMovies{
                    allUIModel.append(self.mapMovieDetailsUIModel(movie))
                }
                if let index = self.moviesListTableViewSections.index(where: {$0.sectionType == .allMovies}) {
                    self.moviesListTableViewSections[index].movies += allUIModel

                }else{
                    let newSection = MoviesListTableViewSection(sectionType: .allMovies,movies: allUIModel)
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
    func downloadMovieImage(_ indexPath: IndexPath) {
        let movieAPIClient = MoviesAPIClient.sharedClient
        movieAPIClient.network = NetworkLayer(session: URLSession.shared)
        let imageCache = MoviesAPIClient.sharedClient.cache
        if (imageCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil) {
            let image = imageCache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            view?.displayMovieImage(image: image!, indexpath: indexPath)
        }else{
            guard let url = getImageURL(indexPath: indexPath) else{
                return
            }
            movieAPIClient.getMoviemage(url, success: { response in
                DispatchQueue.main.async {
                    let image = UIImage(data: response)
                    self.view?.displayMovieImage(image: image!, indexpath: indexPath)
                }
            }) { (error) in
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
    
    //MARK:- Configure movies sections
    
    private func getAllMovies() -> [MovieDetailViewModel]? {
        return moviesListTableViewSections.first(where: {$0.sectionType == .allMovies})?.movies ?? nil
    }
    private func getMyMovies() -> [MovieDetailViewModel]? {
        return moviesListTableViewSections.first(where: {$0.sectionType == .myMovies})?.movies ?? nil
    }
    
    //MARK:- UI Handling
    
    func getMovie(at index: IndexPath) -> MovieDetailViewModel {
        let movies = moviesListTableViewSections[index.section].movies[index.row]
        return movies
    }
    func mapMovieDetailsUIModel(_ movie: Movie) ->  MovieDetailViewModel {
       var movieDetailViewModel = MovieDetailViewModel()
        movieDetailViewModel.title = movie.title
        movieDetailViewModel.overview = movie.overview
        movieDetailViewModel.releaseDate = movie.releaseDate
        movieDetailViewModel.posterPath = movie.posterPath
        movieDetailViewModel.movieDetailsCardStatus = .view
        return movieDetailViewModel
    }
    // MARK:- Handle Add Movie Details
    
    func addNewMovie(_ movie: MovieDetailViewModel) {
        if let index = self.moviesListTableViewSections.index(where: {$0.sectionType == .myMovies}) {
            self.moviesListTableViewSections[index].movies.append(movie)
        }else{
            let newSection = MoviesListTableViewSection(sectionType: .myMovies,movies: [movie])
            self.moviesListTableViewSections.append(newSection)
            self.moviesListTableViewSections.reverse()
            
        }
        view?.reloadData()
    } 
    func navigateToMovieDetailViewController(_ newMovieDetails: @escaping addMovieDetailsAction) {
        router?.configureAddMovieAction(newMovieDetails)
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
