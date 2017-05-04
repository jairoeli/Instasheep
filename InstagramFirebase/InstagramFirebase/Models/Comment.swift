//
//  Comment.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 5/4/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import Foundation

struct Comment {

  let text: String
  let uid: String

  init(dictionary: [String: Any]) {
    self.text = dictionary["text"] as? String ?? ""
    self.uid = dictionary["uid"] as? String ?? ""
  }

}
