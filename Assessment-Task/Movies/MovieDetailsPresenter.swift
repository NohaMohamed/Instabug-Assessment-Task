//
//  MovieDetailsPresenter.swift
//  Assessment-Task
//
//  Created by Noha  on 2/18/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit
protocol MovieDetailsPresenter {
    func viewWillAppear()
}

protocol MovieDetailsPresenterView: class {
}
class MovieDetailsPresenterImplementation : MovieDetailsPresenter {
    
    //MARK-: Properties
    
    fileprivate weak var view: MovieDetailsPresenterView?
    private var movie: Movie?
    
    func viewWillAppear() {
    }
    init(view: MovieDetailsPresenterView) {
        self.view = view
    }
    func mapMovieDetailsUIMode(_ movie: Movie) ->  MovieDetailViewModel {
        var movieDetailViewModel = MovieDetailViewModel()
        movieDetailViewModel.title = movie.title
        movieDetailViewModel.overview = movie.overview
        movieDetailViewModel.releaseDate = movie.releaseDate
        movieDetailViewModel.movieDetailsCardStatus = .view
        return movieDetailViewModel
    }
}
