//
//  UserProfileHeader.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/23/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class UserProfileHeader: UICollectionViewCell {
  
  var user: User? {
    didSet {
      setupProfileImage()
    }
  }
  
  let profileImageView = UIImageView {
    $0.backgroundColor = .red
    $0.layer.cornerRadius = 80 / 2
    $0.clipsToBounds = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .blue
    addSubview(profileImageView)
    
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension UserProfileHeader {
  
  fileprivate func setupLayout() {
    profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
  }
  
  fileprivate func setupProfileImage() {
    guard let profileImageURL = user?.profileImageURL else { return }
    
    guard let url = URL(string: profileImageURL) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, err) in
      // check for the error, then construct the image using data
      if let err = err {
        print("Failed to fetch profile image:", err)
        return
      }
      
      // perhaps check for response status of 200
      guard let data = data else { return }
      let image = UIImage(data: data)
      
      // need to get back onto the main UI thread
      DispatchQueue.main.async {
        self.profileImageView.image = image
      }
      
      }.resume()
  }
  
}
