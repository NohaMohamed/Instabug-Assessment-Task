//
//  UIImageView+Instabug.swift
//  Assessment-Task
//
//  Created by Noha  on 2/17/19.
//  Copyright © 2019 Noha . All rights reserved.
//
import UIKit

extension UIImageView {
    public func imageFromServerURL(url: String){
        let imageCache = MoviesAPIClient.sharedClient.cache
        if (imageCache.object(forKey: url as AnyObject) != nil) {
            self.image = imageCache.object(forKey: url as AnyObject) as? UIImage
        }else{
            MoviesAPIClient.sharedClient.getMoviemage(url, success: { response in
                DispatchQueue.main.async {
                    self.image = UIImage(data: response)
                    imageCache.setObject(self.image!, forKey: url as AnyObject)
                }
            }) { (error) in
                print("la2aaa")
            }
        }
        
    }
}
extension UITextField {
    func setupNonEditable()  {
        borderStyle = .none
        isUserInteractionEnabled = false
    }
}
