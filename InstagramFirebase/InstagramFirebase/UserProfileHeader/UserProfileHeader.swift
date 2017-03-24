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
      usernameLabel.text = user?.username
    }
  }
  
  // MARK: - Properties
  let profileImageView = UIImageView {
    $0.layer.cornerRadius = 80 / 2
    $0.clipsToBounds = true
  }
  
  lazy var gridButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
    return button
  }()
  
  lazy var listButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "list"), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    return button
  }()
  
  lazy var bookmarkButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "ribbon"), for: .normal)
    button.tintColor = UIColor(white: 0, alpha: 0.2)
    return button
  }()
  
  let usernameLabel = UILabel {
    $0.text = "username"
    $0.font = UIFont.boldSystemFont(ofSize: 14)
  }
  
  let postsLabel = UILabel {
    let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "posts", attributes: [NSForegroundColorAttributeName: UIColor.lightGray,
                                                                           NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
    $0.attributedText = attributedText
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  let followersLabel = UILabel {
    let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "followers", attributes: [NSForegroundColorAttributeName: UIColor.lightGray,
                                                                           NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
    $0.attributedText = attributedText
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  let followingLabel = UILabel {
    let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "following", attributes: [NSForegroundColorAttributeName: UIColor.lightGray,
                                                                           NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
    $0.attributedText = attributedText
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  lazy var editProfileButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Edit Profile", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 3
    return button
  }()
  
  // MARK: - Setup
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(profileImageView)
    addSubview(usernameLabel)
    addSubview(editProfileButton)
    
    setupBottomToolbar()
    setupUserStatsView()
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension UserProfileHeader {
  
  fileprivate func setupLayout() {
    profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
    
    usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 0)
    
    editProfileButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
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
  
  fileprivate func setupBottomToolbar() {
    let topDividerView = UIView()
    topDividerView.backgroundColor = .lightGray
    
    let bottomDividerView = UIView()
    bottomDividerView.backgroundColor = .lightGray
    
    let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
    addSubview(stackView)
    addSubview(topDividerView)
    addSubview(bottomDividerView)
    
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    
    stackView.anchor(top: nil, left: leftAnchor, bottom: self.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    
    topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
    bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
  }
  
  fileprivate func setupUserStatsView() {
    let stackView = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
    
    addSubview(stackView)
    stackView.distribution = .fillEqually
    
    stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
  }
  
}
