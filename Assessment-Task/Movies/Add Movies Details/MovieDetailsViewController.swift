//
//  MovieDetailsViewController.swift
//  Assessment-Task
//
//  Created by Noha  on 2/17/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

import UIKit

class MovieDetailsConfigurator: NSObject {
    func configure(movieDetailsViewController: MovieDetailsViewController) {
        let presenter = MovieDetailsPresenterImplementation(view: movieDetailsViewController)
        movieDetailsViewController.presenter = presenter
    }
}

class MovieDetailsViewController: UIViewController  {
    
    //MARK:- Outlets
    @IBOutlet fileprivate weak var moviesDetailsCard: MovieDetailsCustomView!

    //MARK- Properties
    var presenter: MovieDetailsPresenter?
    private var movieDetailsCard: MovieDetailViewModel!
    private var imagePicker = UIImagePickerController()
    var newMovieDetails: addMovieDetailsAction?
    var addedMovie =  MovieDetailViewModel()
    let configurator = MovieDetailsConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(movieDetailsViewController: self)
        setupStyle()
        self.imagePicker.delegate = self
        setupNavigationItem()
        setupAddMovieImage()
        moviesDetailsCard.configureMovieCard(with: movieDetailsCard)
        self.accessibilityLabel = "MovieDetailsViewController"
    }
    
    //MARK:- Setup View Style
    
    private func setupStyle(){
        self.view.backgroundColor = .white
        self.movieDetailsCard = presenter?.mapMoviewDetailsUIModel()
    }
   private func setupNavigationItem() {
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addNewMovieDetails))
        addBarButton.accessibilityIdentifier = "done"
        navigationItem.rightBarButtonItem = addBarButton
    }
    private func setupAddMovieImage(){
        movieDetailsCard.movieImageAddAction = { [weak self] in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                
                
                self?.imagePicker.sourceType = .savedPhotosAlbum;
                self?.imagePicker.allowsEditing = false
                
                self?.present(self!.imagePicker, animated: true, completion: nil)
            }
        }
    }
    @objc func addNewMovieDetails() {
        let movie = self.moviesDetailsCard.fetchMovieDetailsData()
        self.presenter?.configureMovieDetailsData(title: movie.0, releaseDate: movie.2, overview: movie.1)
    }
}
extension MovieDetailsViewController: UINavigationControllerDelegate , UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.moviesDetailsCard.configureMovieImage(with: image)
            self.presenter?.configureMovieImage(image)
        }
        
        imagePicker.dismiss(animated: true, completion: nil);
    }
}
extension MovieDetailsViewController: MovieDetailsPresenterView{
    func configureAddedMovieUIModel(_ movie: MovieDetailViewModel) {
        guard let movieDetailsAction = newMovieDetails  else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        movieDetailsAction(movie)
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
