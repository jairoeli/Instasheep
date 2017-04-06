//
//  Post.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/6/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import Foundation

struct Post {
  let imageURL: String
  
  init(dictionary: [String: Any]) {
    self.imageURL = dictionary["imageURL"] as? String ?? ""
  }
}
