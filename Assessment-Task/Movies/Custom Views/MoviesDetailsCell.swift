//
//  MoviesDetailsCell.swift
//  Assessment-Task
//
//  Created by Noha  on 2/16/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

class MoviesDetailsCell: UITableViewCell {

    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var moviesDetailsView: MovieDetailsCustomView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(with uiModel: MovieDetailViewModel?)  {
        guard uiModel != nil else {
            moviesDetailsView.configureMovieCard(with: uiModel)
            indicatorView.startAnimating()
            return
        }
        moviesDetailsView.configureMovieCard(with: uiModel)
        indicatorView.stopAnimating()
    }
    func configureMovieImage(image: UIImage)  {
        moviesDetailsView.configureMovieImage(with: image)
    }
}
