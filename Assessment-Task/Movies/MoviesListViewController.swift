//
//  MoviesListViewController.swift
//  Assessment-Task
//
//  Created by Noha  on 2/15/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

class MoviesListConfigurator {
    
    func configure(moviesListViewController: MoviesListViewController) {
        let fetchMoviesUseCase = FetchMoviesUseCase()
        let presenter = MoviesListPresenterImplementation(view: moviesListViewController, fetchMoviesUseCase: fetchMoviesUseCase, router: MoviesListRouter())
        moviesListViewController.presenter = presenter
    }
}


class MoviesListViewController: UIViewController {

    //MARK- Outlets
    @IBOutlet private weak var moviesTableView: UITableView!
    var presenter: MoviesListPresenter?
    let configurator = MoviesListConfigurator()
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(moviesListViewController: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.viewWillAppear()
    }

}
extension MoviesListViewController: MoviesListPresenterView {
    func showLoading() {
    }
    
    func hideLoading() {
    }
    
    
}
