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
      guard let comment = comment else { return }

      let attributedText = NSMutableAttributedString(string: comment.user.username,
                                                     attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14)])

      attributedText.append(NSAttributedString(string: " " + comment.text,
                                               attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))

      textLabel.attributedText = attributedText
      profileImageView.loadImage(urlString: comment.user.profileImageURL)
    }
  }

  let textLabel = UITextView() <== {
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.isScrollEnabled = false
    $0.isUserInteractionEnabled = false
  }

  let profileImageView = CustomImageView() <== {
    $0.clipsToBounds = true
    $0.contentMode = .scaleAspectFill
    $0.backgroundColor = .blue
    $0.layer.cornerRadius = 40 / 2
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(profileImageView)
    addSubview(textLabel)
    setupLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  fileprivate func setupLayout() {
    profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
    textLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
  }

}
