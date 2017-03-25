//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/25/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
  
  lazy var signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Don't have an account? Sign Up.", for: .normal)
    button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.isNavigationBarHidden = true
    view.backgroundColor = .white
    view.addSubview(signUpButton)
    
    signUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
  }
  
  func handleShowSignUp() {
    let signUpController = SignUpController()
    navigationController?.pushViewController(signUpController, animated: true)
  }
  
}
