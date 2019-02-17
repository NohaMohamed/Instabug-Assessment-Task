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
    var cache: NSCache<AnyObject, AnyObject>!
    
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
    func configureMoviesView(with imageURL: String){
        cache = NSCache()
        movieImage.imageFromServerURL(url: imageURL, imageCache: cache)
    }
    func hey() {
        print("hey")
    }
    func initializeView() {
        Bundle.main.loadNibNamed("MovieDetailsCustomView", owner: self, options: nil)
        addSubview(self.contentview)
        contentview.frame = self.bounds
        contentview.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
    }
}
