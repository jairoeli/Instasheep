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

  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView?.backgroundColor = .white
    navigationItem.title = FIRAuth.auth()?.currentUser?.uid
    
    fetchUser()
  }
  
  fileprivate func fetchUser() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    
    FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      print(snapshot.value ?? "")
      
      guard let dictionary = snapshot.value as? [String: Any] else { return }
      
      let username = dictionary["username"] as? String
      self.navigationItem.title = username
      
    }) { (err) in
      print("Failed to fetch user:", err)
    }
    
  }
  
}
