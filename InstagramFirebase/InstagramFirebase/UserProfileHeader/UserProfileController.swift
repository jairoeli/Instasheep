//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/22/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  
  fileprivate let headerID = "headerId"
  var user: User?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    navigationItem.title = FIRAuth.auth()?.currentUser?.uid
    
    fetchUser()
    
    collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
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
  
  // MARK: - Collection View
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! UserProfileHeader
    header.user = self.user
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.height, height: 200)
  }
  
}
