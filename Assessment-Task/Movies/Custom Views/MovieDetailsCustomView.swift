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
    func configureMovieCard(with uiModel: MovieDetailViewModel?)  {
        if let mappedModel = uiModel {
            titleTextField.text = mappedModel.title
            overviewTextView.text = mappedModel.overview
            dateTextField.text = mappedModel.releaseDate
            var frame = self.overviewTextView.frame
            frame.size.height = self.overviewTextView.contentSize.height
            overviewTextView.translatesAutoresizingMaskIntoConstraints = false
            overviewTextView.isScrollEnabled = false
            self.overviewTextView.frame = frame
            
            movieImage.alpha = 1
            dateTextField.alpha = 1
            overviewTextView.alpha = 1
            titleTextField.alpha = 1
            if mappedModel.movieDetailsCardStatus == .view {
                dateTextField.setupNonEditable()
                titleTextField.setupNonEditable()
            }else {
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
                movieImage.isUserInteractionEnabled = true
                movieImage.addGestureRecognizer(tapGestureRecognizer)
            }
            layoutIfNeeded()
        }else{
            hideView()
        }
        
    }
    @objc func imageTapped() {
        
    }
    func hideView()  {
        movieImage.alpha = 0
        dateTextField.alpha = 0
        overviewTextView.alpha = 0
        titleTextField.alpha = 0
    }
    func initializeView() {
        Bundle.main.loadNibNamed("MovieDetailsCustomView", owner: self, options: nil)
        addSubview(self.contentview)
        contentview.frame = self.bounds
        contentview.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
    }
}
