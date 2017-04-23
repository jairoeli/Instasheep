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
  let creationDate: Date
  
  init(user: User, dictionary: [String: Any]) {
    self.user = user
    self.imageURL = dictionary["imageURL"] as? String ?? ""
    self.caption = dictionary["caption"] as? String ?? ""
    
    let secondsFrom1970 = dictionary["creationDate"] as? Double ?? 0
    self.creationDate = Date(timeIntervalSince1970: secondsFrom1970)
  }
}
