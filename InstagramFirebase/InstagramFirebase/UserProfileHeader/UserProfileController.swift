//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/22/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {
  
  fileprivate let headerID = "headerId"
  fileprivate let cellId = "cellId"
  var user: User?
  var posts = [Post]()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    navigationItem.title = FIRAuth.auth()?.currentUser?.uid
    
    fetchUser()
    
    collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
    collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
    
    setupLogOutButton()
//    fetchPosts()
    fetchOrderedPosts()
  }
  
  // MARK: - Fetch User & Post
  fileprivate func fetchOrderedPosts() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    let ref = FIRDatabase.database().reference().child("posts").child(uid)
    
    // perhaps later on we'll implement some pagination of data
    ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in
      
      guard let dictionary = snapshot.value as? [String: Any] else { return }
      
      let post = Post(dictionary: dictionary)
      self.posts.append(post)
      
      self.collectionView?.reloadData()
      
    }) { (err) in
      print("Failed to fetch ordered posts:", err)
    }
  }
  
  fileprivate func fetchPosts() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    
    let ref = FIRDatabase.database().reference().child("posts").child(uid)
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
//      print(snapshot.value)
      
      guard let dictionaries = snapshot.value as? [String: Any] else { return }
      
      dictionaries.forEach({ (key, value) in
//        print("Key \(key), Value: \(value)")
        guard let dictionary = value as? [String: Any] else { return }
        
        let post = Post(dictionary: dictionary)
        self.posts.append(post)
      })
      
      self.collectionView?.reloadData()
      
    }) { (err) in
      print("Failed to fetch posts:", err)
    }
  }
  
  fileprivate func fetchUser() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    
    FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      print(snapshot.value ?? "")
      
      guard let dictionary = snapshot.value as? [String: Any] else { return }

      self.user = User(dictionary: dictionary)
      
      self.navigationItem.title = self.user?.username
      self.collectionView?.reloadData()
      
    }) { (err) in
      print("Failed to fetch user:", err)
    }
    
  }
  
  // MARK: - Log out
  
  fileprivate func setupLogOutButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
  }
  
  func handleLogOut() {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    
    alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
      
      do {
        try FIRAuth.auth()?.signOut()
        
        // what happens? we need to present some kind of login controller 
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        self.present(navController, animated: true, completion: nil)
        
      } catch let signOutError {
        print("Failed to sign out:", signOutError)
      }
      
    }))
    
    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(alertController, animated: true, completion: nil)
  }
  
  
  // MARK: - Collectin View data source
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserProfilePhotoCell
    cell.post = posts[indexPath.item]
    return cell
  }
  
}

  // MARK: - Collection View Flow Layout
extension UserProfileController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = (view.frame.width - 2) / 3
    return CGSize(width: width, height: width)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }
  
  // MARK: - Header
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! UserProfileHeader
    header.user = self.user
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.height, height: 200)
  }
}
