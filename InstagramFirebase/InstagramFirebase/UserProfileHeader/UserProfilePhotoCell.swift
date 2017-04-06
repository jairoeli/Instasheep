//
//  UserProfilePhotoCell.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/6/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UICollectionViewCell {
  
  var post: Post? {
    didSet {
      print(post?.imageURL ?? "")
      
      guard let imageURL = post?.imageURL else { return }
      guard let url = URL(string: imageURL) else { return }
      
      URLSession.shared.dataTask(with: url) { (data, response, err) in
        if let err = err {
          print("Failed to fetch post image:", err)
          return
        }
        
        guard let imageData = data else { return }
        
        let photoImage = UIImage(data: imageData)
        
        DispatchQueue.main.async {
          self.photoImageView.image = photoImage
        }
        
      }.resume()
      
    }
  }
  
  let photoImageView = UIImageView {
    $0.backgroundColor = .lightGray
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(photoImageView)
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension UserProfilePhotoCell {
  
  fileprivate func setupLayout() {
    photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
  }
  
}
