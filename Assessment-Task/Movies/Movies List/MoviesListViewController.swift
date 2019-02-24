//
//  MoviesListViewController.swift
//  Assessment-Task
//
//  Created by Noha  on 2/15/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

typealias addMovieDetailsAction = (MovieDetailViewModel) -> Void
class MoviesListViewController: UIViewController {
    
    //MARK- Outlets
    @IBOutlet private weak var moviesTableView: UITableView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    //MARK- Properties
    var presenter: MoviesListPresenter?
    let configurator = MoviesListConfigurator()
    private lazy var newMovieDetails: addMovieDetailsAction = { (addedMovie)  in
        self.indicatorView.stopAnimating()
        self.presenter?.addNewMovie(addedMovie)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorView.startAnimating()
        configurator.configure(moviesListViewController: self)
        configureMoviesTableView()
        setupAddButtonToNavigation()
        presenter?.fetchAvailableMovies()
    }
    
    //MARK:- Setup View Controller
    
    private func setupAddButtonToNavigation() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMovie))
        addBarButton.accessibilityIdentifier = "add"
        navigationItem.rightBarButtonItem = addBarButton
    }
    private func configureMoviesTableView() {
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.prefetchDataSource = self
        let cellNib = UINib(nibName: "MoviesDetailsCell", bundle: nil)
        moviesTableView.register(cellNib, forCellReuseIdentifier: "MoviesDetailsCell")
    }
    
    //MARK:- Movie Details Action
    @objc func addNewMovie()   {
        presenter?.navigateToMovieDetailViewController(newMovieDetails)
    }
}
extension MoviesListViewController: MoviesListPresenterView {
    func showLoading() {
        indicatorView.startAnimating()
    }
    
    func hideLoading() {
        indicatorView.stopAnimating()
    }
    
    func displayMovieImage(image: UIImage, indexpath: IndexPath) {
        if let updateCell = moviesTableView.cellForRow(at: indexpath) {
            (updateCell as! MoviesDetailsCell).configureMovieImage(image: image)
            MoviesAPIClient.sharedClient.cache.setObject(image, forKey: (indexpath as NSIndexPath).row as AnyObject)
        }
    }
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            moviesTableView.reloadData()
            return
        }
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.numberOfSections() ?? 0
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.titleOfSection(section)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  presenter?.numberOfRows(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesDetailsCell", for: indexPath) as! MoviesDetailsCell
        if isLoadingCell(for: indexPath){
            cell.configureCell(with: .none)
        }else   {
            let movieDetails = presenter?.getMovie(at: indexPath)
            cell.configureCell(with: movieDetails ?? MovieDetailViewModel())
            guard movieDetails != nil , movieDetails?.image == nil else {
                cell.configureMovieImage(image: movieDetails!.image!)
                return cell
            }
           if let img = MoviesAPIClient.sharedClient.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) {
                cell.configureMovieImage(image: img as! UIImage)
            }else{
                presenter?.downloadMovieImage(indexPath)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func reloadData() {
        moviesTableView.reloadData()
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
            presenter?.fetchAvailableMovies()
        }
    }
}
