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
}

protocol MoviesListPresenterView: class {
    func showLoading()
    func hideLoading()
    func configureMovies(_ movies: [Movie])
}
class MoviesListPresenterImplementation : MoviesListPresenter {
    
    //MARK-: Properties
    
    fileprivate weak var view: MoviesListPresenterView?
    private var fetchMoviesUseCase: FetchMoviesUseCase
    private var router: MoviesListRouter?
    private var isFetchInProgress: Bool = false
    
    func viewWillAppear() {
        guard !isFetchInProgress else {
            return
        }
        
        fetchMoviesUseCase.execute { allMovies in
            self.view?.configureMovies(allMovies as! [Movie])
        }
    }
    init(view: MoviesListPresenterView,
         fetchMoviesUseCase: FetchMoviesUseCase,
         router: MoviesListRouter) {
        self.view = view
        self.fetchMoviesUseCase = fetchMoviesUseCase
        self.router = router
    }
}
