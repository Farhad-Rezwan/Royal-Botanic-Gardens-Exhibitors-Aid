//
//  CustomImageView.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 18/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit

/// https://www.youtube.com/watch?v=Axe4SoUigLU

let imageCache = NSCache<AnyObject, AnyObject> ()
class CustomImageView: UIImageView {
    
    /// making sure that the cell image view is not malfunctioned
    var task: URLSessionDataTask!
    
    var spinner = UIActivityIndicatorView(style: .large)
    
    /// loading image and showing in the Plant cells using DataTask
    /// - Parameter url: image url
    func loadImage(from url: URL){
        
        image = nil
        
        addSpinner()
        
        if let task = task {
            task.cancel()
            
        }
        
        if let iamgeFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            image = iamgeFromCache
            removeSpinner()
            return
        }

        task = URLSession.shared.dataTask(with: url) {(data, respone, error) in
            
            guard let data = data, let newImage = UIImage(data: data) else {
                print("Couldnot load image form url \(url)")
                return
            }
            
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.image = newImage
                self.removeSpinner()
            }
            
        }
        
        task.resume()
        
    }
    
    
    /// adding spinner when the  image is being downloaded
    func addSpinner() {
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        spinner.startAnimating()
    }
    
    /// when the image is assigned the sppinner is removed
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
}
