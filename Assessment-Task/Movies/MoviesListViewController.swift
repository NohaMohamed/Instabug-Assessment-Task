//
//  MoviesListViewController.swift
//  Assessment-Task
//
//  Created by Noha  on 2/15/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {

    //MARK- Outlets
    @IBOutlet private weak var moviesTableView: UITableView!
    var presenter: MoviesListPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.viewWillAppear()
    }

}
