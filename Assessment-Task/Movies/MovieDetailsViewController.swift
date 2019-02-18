//
//  MovieDetailsViewController.swift
//  Assessment-Task
//
//  Created by Noha  on 2/17/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

class MovieDetailsConfigurator {
    
    func configure(moviesListViewController: MoviesListViewController) {
    }
}

class MovieDetailsViewController: UIViewController {
    
    //MARK- Properties
    var presenter: MoviesListPresenter?
    let configurator = MoviesListConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}
