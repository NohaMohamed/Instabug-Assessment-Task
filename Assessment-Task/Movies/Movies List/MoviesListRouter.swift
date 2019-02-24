//
//  MoviesListRouter.swift
//  Assessment-Task
//
//  Created by Noha  on 2/17/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

protocol Navigator {
    associatedtype Destination
    func navigate(to destination: Destination)
}
enum Destination {
    case addMovieDetails
}
class MoviesListNavigator: Navigator {
    private weak var viewController: MoviesListViewController?
    private var moviesDetailsAction: addMovieDetailsAction?
    
    init(viewController: MoviesListViewController) {
        self.viewController = viewController
    }
    func navigate(to destination: Destination) {
        guard let movieDetailsViewController =  makeViewController(for: destination) else {
            return
        }
        self.viewController?.navigationController?.present(movieDetailsViewController, animated: false)
    }
    func configureAddMovieAction(_ movieDetailsAction: @escaping addMovieDetailsAction) {
        self.moviesDetailsAction = movieDetailsAction
    }
    private func makeViewController(for destination: Destination) -> UINavigationController? {
        switch destination {
        case .addMovieDetails:
            return initateMoviesDetailsViewController() ?? nil
            
        }
    }
    func initateMoviesDetailsViewController() -> UINavigationController? {
        let storyboard = UIStoryboard(name: "Movies", bundle: nil)
        if let moviesDetailsViewController  = storyboard.instantiateViewController(withIdentifier: "movieDetailsViewController") as? MovieDetailsViewController {
            moviesDetailsViewController.newMovieDetails = moviesDetailsAction
            let navController = UINavigationController(rootViewController: moviesDetailsViewController)
            return navController
        }
       return nil
    }
}
