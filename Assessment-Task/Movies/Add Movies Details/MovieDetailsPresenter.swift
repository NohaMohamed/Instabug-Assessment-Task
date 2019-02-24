//
//  MovieDetailsPresenter.swift
//  Assessment-Task
//
//  Created by Noha  on 2/18/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit
protocol MovieDetailsPresenter {
    func mapMoviewDetailsUIModel() -> MovieDetailViewModel
    func configureMovieImage(_ image: UIImage?)
    func configureMovieDetailsData(title: String? , releaseDate: String?, overview: String?)
}

protocol MovieDetailsPresenterView: class {
    func configureAddedMovieUIModel(_ movie: MovieDetailViewModel)
}
class MovieDetailsPresenterImplementation : MovieDetailsPresenter {
    
    //MARK-: Properties
    
    fileprivate weak var view: MovieDetailsPresenterView?
    private var movie: Movie?
    private var movieDetailsCard = MovieDetailViewModel()
    
    init(view: MovieDetailsPresenterView) {
        self.view = view
    }
    func mapMoviewDetailsUIModel() -> MovieDetailViewModel {
        movieDetailsCard.movieDetailsCardStatus = .add
        movieDetailsCard.overview = "Write your description"
        return movieDetailsCard
    }
    func configureMovieImage(_ image: UIImage?) {
        movieDetailsCard.image = image
    }
    func configureMovieDetailsData(title: String?, releaseDate: String?, overview: String?) {
        movieDetailsCard.title = title ?? ""
        movieDetailsCard.overview = overview ?? ""
        movieDetailsCard.releaseDate = releaseDate ?? ""
        view?.configureAddedMovieUIModel(movieDetailsCard)
    }
    

}
