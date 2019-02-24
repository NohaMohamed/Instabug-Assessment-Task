//
//  MoviesListConfigurator.swift
//  Assessment-Task
//
//  Created by Noha  on 2/24/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

class MoviesListConfigurator: NSObject {
    func configure(moviesListViewController: MoviesListViewController) {
        let fetchMoviesUseCase = FetchMoviesUseCase()
        let router = MoviesListNavigator(viewController: moviesListViewController)
        let presenter = MoviesListPresenterImplementation(view: moviesListViewController, fetchMoviesUseCase: fetchMoviesUseCase, router: router)
        moviesListViewController.presenter = presenter
    }
}
