//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/7/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController {
  
  private let cellId = "cellId"
  var posts = [Post]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = .white
    
    collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
    
    setupNavigationItems()
    fetchPosts()
    fetchFollowingUserIds()
  }
  
  func setupNavigationItems() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
  }
  
  // MARK: - Firebase
  
  fileprivate func fetchPosts() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    
    FIRDatabase.fetchUserWith(uid: uid) { (user) in
      self.fetchPostsWith(user: user)
    }
    
  }
  
  fileprivate func fetchPostsWith(user: User) {
    
    let ref = FIRDatabase.database().reference().child("posts").child(user.uid)
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
      
      guard let dictionaries = snapshot.value as? [String: Any] else { return }
      
      dictionaries.forEach({ (key, value) in
        guard let dictionary = value as? [String: Any] else { return }
        
        let post = Post(user: user, dictionary: dictionary)
        self.posts.append(post)
      })
      
      self.posts.sort(by: { (p1, p2) -> Bool in
        return p1.creationDate.compare(p2.creationDate) == .orderedDescending
      })
      
      self.collectionView?.reloadData()
      
    }) { (err) in
      print("Failed to fetch posts:", err)
    }
  }
  
  fileprivate func fetchFollowingUserIds() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    FIRDatabase.database().reference().child("Following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      
      guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
      
      userIdsDictionary.forEach({ (key, value) in
        FIRDatabase.fetchUserWith(uid: key, completion: { (user) in
          self.fetchPostsWith(user: user)
        })
      })
      
    }) { (err) in
      print("Failed to fetch following user ids: ", err)
    }
  }
  
  // MARK: - UICollectionView
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomePostCell else { return UICollectionViewCell() }
    
    cell.post = posts[indexPath.item]
    return cell
  }
  
}

// MARK: - UICollectionView Flow Layout
extension HomeController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var height: CGFloat = 40 + 8 + 8  // username userprofileimageview
    height += view.frame.width
    height += 50
    height += 60
    
    return CGSize(width: view.frame.width, height: height)
  }
  
}
