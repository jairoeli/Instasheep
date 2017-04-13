//
//  User.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/23/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import Foundation

struct User {
  
  let uid: String
  let username: String
  let profileImageURL: String
  
  init(uid: String, dictionary: [String: Any]) {
    self.uid = uid
    self.username = dictionary["username"] as? String ?? ""
    self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
  }
}
