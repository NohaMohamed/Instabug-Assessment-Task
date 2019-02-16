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
}
class MoviesListPresenterImplementation : MoviesListPresenter {
    fileprivate weak var view: MoviesListPresenterView?
    private var fetchMoviesUseCase: FetchMoviesUseCase
    private var router: MoviesListRouter?
    
    func viewWillAppear() {
        fetchMoviesUseCase = FetchMoviesUseCase()
        fetchMoviesUseCase.execute {
            
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
