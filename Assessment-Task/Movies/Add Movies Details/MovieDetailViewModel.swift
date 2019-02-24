//
//  MovieDetailsViewModel.swift
//  Assessment-Task
//
//  Created by Noha  on 2/17/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

typealias movieImageAction = (() -> Void)

struct MovieDetailViewModel {
    var title = ""
    var releaseDate = ""
    var overview = ""
    var posterPath = ""
    var image: UIImage?
    var movieDetailsCardStatus: MovieDetailsCardStatus = .view
    var movieImageAddAction: movieImageAction?
    var sectionType = SectionType.allMovies
    init() {}
    init(title: String, overview: String, releaseDate: String) {
        self.title = title
        self.releaseDate = releaseDate
        self.overview = overview
    }
}
