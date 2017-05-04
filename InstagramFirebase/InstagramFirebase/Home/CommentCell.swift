//
//  CommentCell.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 5/4/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class CommentCell: UICollectionViewCell {

  var comment: Comment? {
    didSet {
      textLabel.text = comment?.text
    }
  }

  let textLabel = UILabel() <== {
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.numberOfLines = 0
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .yellow
    addSubview(textLabel)
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  fileprivate func setupLayout() {
    textLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
  }


}
