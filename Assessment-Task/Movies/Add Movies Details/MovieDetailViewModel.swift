//
//  MovieDetailsViewModel.swift
//  Assessment-Task
//
//  Created by Noha  on 2/17/19.
//  Copyright © 2019 Noha . All rights reserved.
//


struct MovieDetailViewModel {
    var title = ""
    var releaseDate = ""
    var overview = ""
    var movieDetailsCardStatus: MovieDetailsCardStatus = .view
    var movieImageAddAction: (() -> Void)?
    init() {}
    init(title: String, overview: String, releaseDate: String) {
        self.title = title
        self.releaseDate = releaseDate
        self.overview = overview
    }
}
