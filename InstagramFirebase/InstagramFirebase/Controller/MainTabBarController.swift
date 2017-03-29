//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/22/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if FIRAuth.auth()?.currentUser == nil {
      // show if not logged in
      DispatchQueue.main.async {
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        self.present(navController, animated: true, completion: nil)
      }
      return
    }
    
    setupViewControllers()
  }
  
  func setupViewControllers() {
    let layout = UICollectionViewFlowLayout()
    let userProfileController = UserProfileController(collectionViewLayout: layout)
    
    let navController = UINavigationController(rootViewController: userProfileController)
    
    navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
    navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
    
    tabBar.tintColor = .black
    
    viewControllers = [navController, UIViewController()]
  }
  
}
