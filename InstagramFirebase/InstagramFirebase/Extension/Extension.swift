//
//  Extension.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/21/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol Dao {}
extension NSObject: Dao {}

extension Dao where Self: NSObject {
  
  init(closure: (Self) -> Void) {
    self.init()
    closure(self)
  }
  
}

extension Dao where Self: UIButton {
  
  init(type: UIButtonType, closure: (Self) -> Void) {
    self = UIButton(type: type) as! Self
    closure(self)
  }
  
}

extension UIView {
  func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
      self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    
    if let left = left {
      self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    
    if let bottom = bottom {
      bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
    }
    
    if let right = right {
      rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    
    if width != 0 {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    if height != 0 {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }
  
}

extension UIColor {
  
  static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
  }
  
}

extension FIRDatabase {
  static func fetchUserWith(uid: String, completion: @escaping (User) -> ()) {
    
    FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
      guard let userDicitonary = snapshot.value as? [String: Any] else { return }
      
      let user = User(uid: uid, dictionary: userDicitonary)
      completion(user)
      
    }) { (err) in
      print("Failed to fetch user for posts:", err)
    }
    
  }
}
