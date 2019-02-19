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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieDetailsCard.movieDetailsCardStatus = .add
        movieDetailsCard.movieImageAddAction = {
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Button capture")
                
                self.imagePicker.delegate = self 
                self.imagePicker.sourceType = .savedPhotosAlbum;
                self.imagePicker.allowsEditing = false
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
}
