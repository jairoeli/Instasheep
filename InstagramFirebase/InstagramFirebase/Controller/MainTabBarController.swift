//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/22/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let layout = UICollectionViewFlowLayout()
    let userProfileController = UserProfileController(collectionViewLayout: layout)
    
    
    let navController = UINavigationController(rootViewController: userProfileController)
    
    navController.tabBarItem.image = #imageLiteral(resourceName: "profile_unselected")
    navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "profile_selected")
    
    tabBar.tintColor = .black
    
    viewControllers = [navController, UIViewController()]
  }
  
}
