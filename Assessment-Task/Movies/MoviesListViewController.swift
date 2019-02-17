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
    
    //MARK- Properties
    var presenter: MoviesListPresenter?
    let configurator = MoviesListConfigurator()
    var allMovies : [Movie]? {
        didSet{
            DispatchQueue.main.async {
                self.moviesTableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(moviesListViewController: self)
        moviesTableView.dataSource = self
        moviesTableView.prefetchDataSource = self
        let cellNib = UINib(nibName: "MoviesDetailsCell", bundle: nil)
        moviesTableView.register(cellNib, forCellReuseIdentifier: "MoviesDetailsCell")
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
    func configureMovies(_ movies: [Movie]) {
        allMovies = movies
    }
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        // 1
        guard let newIndexPathsToReload = newIndexPathsToReload else {
//            indicatorView.stopAnimating()
//            tableView.isHidden = false
            moviesTableView.reloadData()
            return
        }
        // 2
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        moviesTableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with reason: String) {
       /* indicatorView.stopAnimating()
        
        let title = "Warning".localizedString
        let action = UIAlertAction(title: "OK".localizedString, style: .default)
        displayAlert(with: title , message: reason, actions: [action])*/
    }
}
extension MoviesListViewController:  UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesDetailsCell", for: indexPath) as! MoviesDetailsCell
        cell.configureCell(imageURL: allMovies![indexPath.row].posterPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
private extension MoviesListViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        print("======\(indexPath.row)")
        return indexPath.row >= presenter?.moviesCount() ?? 0
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = moviesTableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}
extension MoviesListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            presenter?.viewWillAppear()
        }
    }
}
