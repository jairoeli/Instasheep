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
      guard let profileImageURL = user?.profileImageURL else { return }
      profileImageView.loadImage(urlString: profileImageURL)
      usernameLabel.text = user?.username
      setupEditFollowButton()
    }
  }
  
  // MARK: - Properties
  let profileImageView = CustomImageView {
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
    $0.font = UIFont.boldSystemFont(ofSize: 14)
  }
  
  let postsLabel = UILabel {
    let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "posts", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
    $0.attributedText = attributedText
    $0.textAlignment = .center
    $0.numberOfLines = 0
  }
  
  let followersLabel = UILabel {
    let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
    attributedText.append(NSAttributedString(string: "followers", attributes: [NSForegroundColorAttributeName: UIColor.lightGray, NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
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
  
  lazy var editProfileFollowButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Edit Profile", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.layer.borderColor = UIColor.lightGray.cgColor
    button.layer.borderWidth = 1
    button.layer.cornerRadius = 3
    button.addTarget(self, action: #selector(handleEditProfileOrFollow), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Initializing
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(profileImageView)
    addSubview(usernameLabel)
    addSubview(editProfileFollowButton)
    
    setupBottomToolbar()
    setupUserStatsView()
    setupLayout()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}

extension UserProfileHeader {
  // MARK: - Layout
  fileprivate func setupLayout() {
    profileImageView.anchor(top: topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
    
    usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0,height: 0)
    
    editProfileFollowButton.anchor(top: postsLabel.bottomAnchor, left: postsLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, paddingTop: 2, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 34)
  }
  // MARK: - Set up
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
  
  fileprivate func setupEditFollowButton() {
    guard let currentLoggedInUserId = FIRAuth.auth()?.currentUser?.uid else { return }
    
    guard let userID = user?.uid else { return }
    
    if currentLoggedInUserId == userID {
      // edit profile
    } else {
      // Check if following
      FIRDatabase.database().reference().child("Following").child(currentLoggedInUserId).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
        
        if let isFollowing = snapshot.value as? Int, isFollowing == 1 {
          self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
        } else {
          self.setupFollowStyle()
        }
        
      }, withCancel: { (err) in
        print("Failed to check if following:", err)
      })
    }
    
  }
  
  func handleEditProfileOrFollow() {
    guard let currentLoggedInUserID = FIRAuth.auth()?.currentUser?.uid else { return }
    guard let userID = user?.uid else { return }
    
    if editProfileFollowButton.titleLabel?.text == "Unfollow" {
      // Unfollow
      FIRDatabase.database().reference().child("Following").child(currentLoggedInUserID).child(userID).removeValue(completionBlock: { (err, ref) in
        if let err = err { print("Failed to unfolllow user: ", err); return }
        print("Successfully unfollowed user:", self.user?.username ?? "")
        self.setupFollowStyle()
      })
      
    } else {
      // follow
      let ref = FIRDatabase.database().reference().child("Following").child(currentLoggedInUserID)
      let values = [userID: 1]
      
      ref.updateChildValues(values) { (err, ref) in
        if let err = err { print("Failed to follow user:", err); return }
        print("Successfully followed user: ", self.user?.username ?? "")
        self.editProfileFollowButton.setTitle("Unfollow", for: .normal)
        self.editProfileFollowButton.backgroundColor = .white
        self.editProfileFollowButton.setTitleColor(.black, for: .normal)
      }
    }
  }
  
  fileprivate func setupFollowStyle() {
    self.editProfileFollowButton.setTitle("Follow", for: .normal)
    self.editProfileFollowButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
    self.editProfileFollowButton.setTitleColor(.white, for: .normal)
    self.editProfileFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
  }
  
}
