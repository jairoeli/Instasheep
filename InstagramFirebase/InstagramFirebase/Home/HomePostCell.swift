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
  
  let userProfileImageView = CustomImageView {
    $0.backgroundColor = .blue
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 40 / 2
  }
  
  let photoImageView = CustomImageView {
    $0.backgroundColor = .white
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  let usernameLabel = UILabel {
    $0.text = "Username"
    $0.font = UIFont.boldSystemFont(ofSize: 14)
  }
  
  lazy var optionsButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("•••", for: .normal)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  lazy var commentButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  lazy var likeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  lazy var sendMessageButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  lazy var bookmarkButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
    return button
  }()
  
  let captionLabel = UILabel {
    let attributedText = NSMutableAttributedString(string: "Username", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: " Some caption text that will perhaps wrap onto the next line.", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
    attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 4)]))
    attributedText.append(NSAttributedString(string: "1 week ago", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.gray]))
    $0.attributedText = attributedText
    $0.numberOfLines = 0
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  fileprivate func setup() {
    addSubview(userProfileImageView)
    addSubview(usernameLabel)
    addSubview(optionsButton)
    addSubview(photoImageView)
    addSubview(captionLabel)
    setupLayout()
  }
  
}

extension HomePostCell {
  
  fileprivate func setupLayout() {
    userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
    
    usernameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: photoImageView.topAnchor, right: optionsButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    
    optionsButton.anchor(top: topAnchor, left: nil, bottom: photoImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 44, height: 0)
    
    photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
    
    setupActionButtons()
    
    captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
  }
  
  fileprivate func setupActionButtons() {
    let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
    
    stackView.distribution = .fillEqually
    addSubview(stackView)
    
    stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
    
    addSubview(bookmarkButton)
    bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 40, height: 50)
  }
  
}

