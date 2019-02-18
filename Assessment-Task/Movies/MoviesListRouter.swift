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
    private weak var navigationController: UINavigationController?
    enum Destination {
        case addMovieDetails
    }
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func navigate(to destination: Destination) {
        let viewController = makeViewController(for: destination)
        navigationController?.pushViewController(viewController, animated: true)
    }
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .addMovieDetails:
            return MovieDetailsViewController()
            
        }
    }
    func kh() -> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let moviesDetailsViewController  = storyboard.instantiateViewController(withIdentifier: "moviesDetailsViewController") as? MovieDetailsViewController {
            return moviesDetailsViewController
        }
        return nil
    }
}
