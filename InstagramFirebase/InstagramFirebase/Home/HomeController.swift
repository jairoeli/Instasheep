//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/7/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, HomePostCellDelegate {
  
  private let cellId = "cellId"
  var posts = [Post]()
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
    collectionView?.backgroundColor = .white
    
    collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    collectionView?.refreshControl = refreshControl
    
    setupNavigationItems()
    fetchAllPosts()
  }
  
  func setupNavigationItems() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
  }
  
  func handleCamera() {
    let cameraController = CameraController()
    present(cameraController, animated: true, completion: nil)
  }
  
  func handleRefresh() {
    posts.removeAll()
    fetchAllPosts()
  }
  
  // MARK: - Notification
  func handleUpdateFeed() {
    handleRefresh()
  }
  
  // MARK: - Firebase
  
  fileprivate func fetchAllPosts() {
    fetchPosts()
    fetchFollowingUserIds()
  }
  
  fileprivate func fetchPosts() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    
    FIRDatabase.fetchUserWith(uid: uid) { (user) in
      self.fetchPostsWith(user: user)
    }
    
  }
  
  fileprivate func fetchPostsWith(user: User) {
    
    let ref = FIRDatabase.database().reference().child("posts").child(user.uid)
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
      
      self.collectionView?.refreshControl?.endRefreshing()
      
      guard let dictionaries = snapshot.value as? [String: Any] else { return }
      
      dictionaries.forEach({ (key, value) in
        guard let dictionary = value as? [String: Any] else { return }
        
        var post = Post(user: user, dictionary: dictionary)
        post.id = key
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
  
  // MARK: - Delegate
  
  func didTapComment(post: Post) {
    print(post.caption)
    let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
    commentsController.post = post 
    navigationController?.pushViewController(commentsController, animated: true)
  }
  
  // MARK: - UICollectionView
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomePostCell else { return UICollectionViewCell() }
    
    cell.post = posts[indexPath.item]
    cell.delegate = self
    
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
