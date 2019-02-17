//
//  MovieDetailsCustomView.swift
//  Assessment-Task
//
//  Created by Noha  on 2/16/19.
//  Copyright © 2019 Noha . All rights reserved.
//

import UIKit

enum MovieDetailsCardStatus {
    case add
    case view
}
class MovieDetailsCustomView: UIView {
    
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private var contentview: UIView!
    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var dateTextField: UITextField!
    @IBOutlet private weak var overviewTextView: UITextView!
    @IBOutlet weak var height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initializeView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initializeView()
    }
    func configureMovieImage(with image: UIImage){
        self.movieImage.image = image
    }
    func configureMovieCard(with uiModel: MovieDetailViewModel)  {
        titleTextField.text = uiModel.title
        overviewTextView.text = uiModel.overview
        dateTextField.text = uiModel.releaseDate
        var frame = self.overviewTextView.frame
        frame.size.height = self.overviewTextView.contentSize.height
        overviewTextView.translatesAutoresizingMaskIntoConstraints = false
        overviewTextView.isScrollEnabled = false
        self.overviewTextView.frame = frame
        
        if uiModel.movieDetailsCardStatus == .view {
            dateTextField.setupNonEditable()
            titleTextField.setupNonEditable()
//            overviewTextView.setupNonEditable()
        }
        self.layoutIfNeeded()
    }
    func initializeView() {
        Bundle.main.loadNibNamed("MovieDetailsCustomView", owner: self, options: nil)
        addSubview(self.contentview)
        contentview.frame = self.bounds
        contentview.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
    }
}
