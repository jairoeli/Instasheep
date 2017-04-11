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
  }
  
  func setupNavigationItems() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
  }
  
  fileprivate func fetchPosts() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    
    let ref = FIRDatabase.database().reference().child("posts").child(uid)
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
      
      guard let dictionaries = snapshot.value as? [String: Any] else { return }
      
      dictionaries.forEach({ (key, value) in
        guard let dictionary = value as? [String: Any] else { return }
        
        let post = Post(dictionary: dictionary)
        self.posts.append(post)
      })
      
      self.collectionView?.reloadData()
      
    }) { (err) in
      print("Failed to fetch posts:", err)
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
