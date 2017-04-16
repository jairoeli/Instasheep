//
//  UserSearchController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/13/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
  
  // MARK: - Properties
  
  fileprivate let cellId = "cellId"
  var users = [User]()
  var filteredUsers = [User]()
  
  lazy var searchBar = UISearchBar {
    $0.placeholder = "Enter username"
    $0.barTintColor = .gray
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
    $0.delegate = self
  }
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = .white
    
    navigationController?.navigationBar.addSubview(searchBar)
    
    setupLayout()
    
    collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: cellId)
    collectionView?.alwaysBounceVertical = true
    
    fetchUsers()
  }
  
  fileprivate func fetchUsers() {
    print("Fetching users")
    let ref = FIRDatabase.database().reference().child("users")
    ref.observeSingleEvent(of: .value, with: { (snapshot) in
      
      guard let dictionaries = snapshot.value as? [String: Any] else { return }
      
      dictionaries.forEach({ (key, value) in
        guard let userDictionary = value as? [String: Any] else { return }
        
        let user = User(uid: key, dictionary: userDictionary)
        self.users.append(user)
      })
      
      self.users.sort(by: { (u1, u2) -> Bool in
        return u1.username.lowercased().compare(u2.username.lowercased()) == .orderedAscending
      })
      
      self.filteredUsers = self.users
      self.collectionView?.reloadData()
      
    }) { (err) in
      print("Failed to fetch users for search!", err)
    }
  }
  
  // MARK: - Search bar
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//    self.users = self.users.filter { (user) -> Bool in
//      return user.username.contains(searchText)
//    }
    
    if searchText.isEmpty {
      filteredUsers = users
    } else {
      filteredUsers = self.users.filter { $0.username.lowercased().contains(searchText.lowercased()) }
    }
    
    self.collectionView?.reloadData()
  }
  
  // MARK: - Collection View
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filteredUsers.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserSearchCell
    
    cell.user = filteredUsers[indexPath.item]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 66)
  }
  
}

// MARK: - Layout
extension UserSearchController {
  fileprivate func setupLayout() {
    let navBar = navigationController?.navigationBar
    
    searchBar.anchor(top: navBar?.topAnchor, left: navBar?.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
  }
  
}
