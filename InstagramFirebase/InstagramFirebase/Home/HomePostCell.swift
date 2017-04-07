//
//  HomePostCell.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/7/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class HomePostCell: UICollectionViewCell {
  
  var post: Post? {
    didSet {
      guard let postImageURL = post?.imageURL else { return }
      photoImageView.loadImage(urlString: postImageURL)
    }
  }
  
  let photoImageView = CustomImageView {
    $0.backgroundColor = .white
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func setup() {
    addSubview(photoImageView)
    setupLayout()
  }
  
}

extension HomePostCell {
  
  fileprivate func setupLayout() {
    photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
  }
  
}
