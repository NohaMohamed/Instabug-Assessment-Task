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

class MovieDetailsViewController: UIViewController ,UINavigationControllerDelegate , UIImagePickerControllerDelegate {
    
    //MARK- Properties
    var presenter: MoviesListPresenter?
    let configurator = MoviesListConfigurator()
    @IBOutlet private weak var moviesDetailsCard: MovieDetailsCustomView!
    private var movieDetailsCard = MovieDetailViewModel()
    private var imagePicker = UIImagePickerController()
    var newMovieDetails: ((Movie) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addNewMovieDetails))
        navigationItem.rightBarButtonItem = addBarButton
        
        self.view.backgroundColor = .white
        movieDetailsCard.movieDetailsCardStatus = .add
        movieDetailsCard.movieImageAddAction = { [weak self] in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Button capture")
                
                self?.imagePicker.delegate = self
                self?.imagePicker.sourceType = .savedPhotosAlbum;
                self?.imagePicker.allowsEditing = false
                
                self?.present(self!.imagePicker, animated: true, completion: nil)
            }
        }
        movieDetailsCard.overview = "Write your desc"
        moviesDetailsCard.configureMovieCard(with: movieDetailsCard)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @objc func addNewMovieDetails(){
        self.dismiss(animated: true) {
            let movieDetails = MoviesListTableViewSection(sectionType: .myMovies, movies: [])
            let movie = Movie(title: "new", overview: "Nemo", releaseDate: "24-8")
            self.newMovieDetails!(movie)
        }
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
}
