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
        viewController?.present(movieDetailsViewController, animated: false, completion: nil)
    }
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .addMovieDetails:
            return MovieDetailsViewController()
            
        }
    }
    func kh() -> UIViewController? {
        
        let storyboard = UIStoryboard(name: "Movies", bundle: nil)
        if let moviesDetailsViewController  = storyboard.instantiateViewController(withIdentifier: "movieDetailsViewController") as? MovieDetailsViewController {
            return moviesDetailsViewController
        }
        return nil
    }
}
