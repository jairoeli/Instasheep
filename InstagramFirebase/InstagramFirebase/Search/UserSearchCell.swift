//
//  UserSearchCell.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/13/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class UserSearchCell: UICollectionViewCell {
  
  var user: User? {
    didSet {
      usernameLabel.text = user?.username
      
      guard let profileImageURL = user?.profileImageURL else { return }
      profileImageView.loadImage(urlString: profileImageURL)
    }
  }
  
  let profileImageView = CustomImageView() <== {
    $0.backgroundColor = .lightGray
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 50 / 2
  }
  
  let usernameLabel = UILabel() <== {
    $0.font = UIFont.boldSystemFont(ofSize: 14)
  }
  
  let separatorView = UIView() <== {
    $0.backgroundColor = UIColor(white: 0, alpha: 0.5)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(profileImageView)
    addSubview(usernameLabel)
    addSubview(separatorView)
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupLayout() {
    profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
    profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
    usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    separatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
  }
  
  
  
}
