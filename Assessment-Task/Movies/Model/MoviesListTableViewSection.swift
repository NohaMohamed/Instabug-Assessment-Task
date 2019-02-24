//
//  MoviesListTableViewSection.swift
//  Assessment-Task
//
//  Created by Noha  on 2/24/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

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
    var movies: [MovieDetailViewModel]
    init(sectionType: SectionType, movies: [MovieDetailViewModel]) {
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
