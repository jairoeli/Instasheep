//
//  CustomImageView.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/6/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {
  
  var lastURLUsedToLoadImage: String?
  
  func loadImage(urlString: String) {
    print("Loading image...")
    
    lastURLUsedToLoadImage = urlString
    
    guard let url = URL(string: urlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, err) in
      if let err = err {
        print("Failed to fetch post image:", err)
        return
      }
      
      if url.absoluteString != self.lastURLUsedToLoadImage {
        return
      }
      
      guard let imageData = data else { return }
      
      let photoImage = UIImage(data: imageData)
      
      DispatchQueue.main.async {
        self.image = photoImage
      }
      
      }.resume()
  }
  
}
