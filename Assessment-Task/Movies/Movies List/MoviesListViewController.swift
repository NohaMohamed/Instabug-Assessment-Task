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
        let router = MoviesListNavigator(viewController: moviesListViewController)
        let presenter = MoviesListPresenterImplementation(view: moviesListViewController, fetchMoviesUseCase: fetchMoviesUseCase, router: router)
        moviesListViewController.presenter = presenter
    }
}
class MoviesListTableViewSection {
    var sectionTitle : String = ""
    var sectionType: SectionType {
        didSet{
            switch sectionType {
            case .allMovies:
                sectionTitle = "All Movies"
            case .myMovies:
                sectionTitle = "My Movies"
            }
        }
    }
    var movies: [Movie]
    init(sectionType: SectionType, movies: [Movie]) {
//        self.sectionTitle = ""
        self.sectionType = sectionType
        self.movies = movies
        defer {
            self.sectionType = sectionType
        }
    }
}
enum SectionType {
    case allMovies
    case myMovies
}
class MoviesListViewController: UIViewController {
    
    //MARK- Outlets
    @IBOutlet private weak var moviesTableView: UITableView!
    var indicatorView : UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 100, y: 100, width: 50, height: 50)) as UIActivityIndicatorView
    
    //MARK- Properties
    var presenter: MoviesListPresenter?
    let configurator = MoviesListConfigurator()
    private lazy var newMovieDetails: (Movie) -> Void = { (addedMovie) in
        self.presenter?.addNewMovie(addedMovie)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        indicatorView.center = self.view.center
        indicatorView.hidesWhenStopped = true
        indicatorView.style = .whiteLarge
        indicatorView.startAnimating()
        self.view.addSubview(indicatorView)
        indicatorView.color = UIColor.red
        configurator.configure(moviesListViewController: self)
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.prefetchDataSource = self
        let cellNib = UINib(nibName: "MoviesDetailsCell", bundle: nil)
        moviesTableView.register(cellNib, forCellReuseIdentifier: "MoviesDetailsCell")
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
        navigationItem.rightBarButtonItem = addBarButton
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presenter?.viewWillAppear()
    }
    @objc func add()   {
        let storyboard = UIStoryboard(name: "Movies", bundle: nil)
        if let moviesDetailsViewController  = storyboard.instantiateViewController(withIdentifier: "movieDetailsViewController") as? MovieDetailsViewController {
            moviesDetailsViewController.newMovieDetails = self.newMovieDetails
            let navController = UINavigationController(rootViewController: moviesDetailsViewController)
            self.navigationController?.present(navController, animated: false)
        }
        
//        presenter?.navigateToMovieDetailViewController()
    }
}
extension MoviesListViewController: MoviesListPresenterView {
    
    func retu(image: UIImage, indexpath: IndexPath) {
        if let updateCell = moviesTableView.cellForRow(at: indexpath) {
            (updateCell as! MoviesDetailsCell).configureMovieImage(image: image)
            MoviesAPIClient.sharedClient.cache.setObject(image, forKey: (indexpath as NSIndexPath).row as AnyObject)
        }
    }
    
    func showLoading() {
        indicatorView.startAnimating()
    }
    
    func hideLoading() {
        indicatorView.stopAnimating()
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
    func retu(image: UIImage) {
        
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
        
        return  presenter?.totalCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MoviesDetailsCell", for: indexPath) as! MoviesDetailsCell
        if isLoadingCell(for: indexPath)
        {
            cell.configureCell(with: .none)
        }else   {
            let movieDetails = presenter?.getMovie(at: indexPath.row)
            cell.configureCell(with: movieDetails ?? MovieDetailViewModel())
            if let img = MoviesAPIClient.sharedClient.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) {
                cell.configureMovieImage(image: img as! UIImage)
            }else{
                presenter?.fun(indexPath: indexPath)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            indicatorView.startAnimating()
            indicatorView.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
            
            self.moviesTableView.tableFooterView = indicatorView
            self.moviesTableView.tableFooterView?.isHidden = false
        }
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
            presenter?.viewWillAppear()
        }
    }
}
