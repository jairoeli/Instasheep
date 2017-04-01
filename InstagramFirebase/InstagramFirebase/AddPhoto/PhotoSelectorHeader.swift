//
//  PhotoSelectorHeader.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/1/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class PhotoSelectorHeader: UICollectionViewCell {
  
  let photoImageView = UIImageView {
    $0.backgroundColor = .cyan
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

extension PhotoSelectorHeader {
  
  fileprivate func setupLayout() {
    photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
  }
  
}
