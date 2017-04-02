//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/2/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController {
  
  var selectedImage: UIImage? {
    didSet {
      self.imageView.image = selectedImage
    }
  }
  
  let containerView = UIView {
    $0.backgroundColor = .white
  }
  
  let imageView = UIImageView {
    $0.backgroundColor = .red
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  let textView = UITextView {
    $0.font = UIFont.systemFont(ofSize: 14)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
    
    setupImageAndTextViews()
  }
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  func handleShare() {
    print("Sharing photo")
  }
  
  fileprivate func setupImageAndTextViews() {
    view.addSubview(containerView)
    containerView.addSubview(imageView)
    containerView.addSubview(textView)
    
    containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    
    imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
    
    textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
  }
  
}
