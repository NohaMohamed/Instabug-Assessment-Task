//
//  MoviesDetailsCell.swift
//  Assessment-Task
//
//  Created by Noha  on 2/16/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

class MoviesDetailsCell: UITableViewCell {

    
    @IBOutlet private weak var moviesDetailsView: MovieDetailsCustomView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        moviesDetailsView.hey()
    }

}
