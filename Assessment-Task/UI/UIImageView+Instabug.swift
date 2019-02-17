//
//  UIImageView+Instabug.swift
//  Assessment-Task
//
//  Created by Noha  on 2/17/19.
//  Copyright © 2019 Noha . All rights reserved.
//
import UIKit

extension UIImageView {
    public func imageFromServerURL(url: String, imageCache: NSCache<AnyObject, AnyObject>){
        if (imageCache.object(forKey: url as AnyObject) != nil) {
            self.image = imageCache.object(forKey: url as AnyObject) as? UIImage
        }else{
            MoviesAPIClient.sharedClient.getMoviemage(url, success: { (_) in
                
            }) { (error) in
                print("la2aaa")
            }
        }
        
    }
}
