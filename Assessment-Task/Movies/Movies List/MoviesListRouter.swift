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

class MoviesListNavigator: Navigator {
    private weak var viewController: MoviesListViewController?
    enum Destination {
        case addMovieDetails
    }
    init(viewController: MoviesListViewController) {
        self.viewController = viewController
    }
    func navigate(to destination: Destination) {
        let movieDetailsViewController = makeViewController(for: destination)
        viewController?.navigationController?.pushViewController(movieDetailsViewController, animated: true)
    }
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .addMovieDetails:
            return MovieDetailsViewController()
            
        }
    }
    func kh() -> UIViewController? {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let moviesDetailsViewController  = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? UINavigationController, let vc = moviesDetailsViewController.topViewController as? MovieDetailsViewController {
            return vc
        }
        return nil
    }
}
