//
//  Post.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/6/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import Foundation

struct Post {
  
  let user: User
  let imageURL: String
  let caption: String
  
  init(user: User, dictionary: [String: Any]) {
    self.user = user
    self.imageURL = dictionary["imageURL"] as? String ?? ""
    self.caption = dictionary["caption"] as? String ?? ""
  }
}
