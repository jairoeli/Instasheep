//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/2/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
  
  // MARK: - Properties
  var selectedImage: UIImage? {
    didSet {
      self.imageView.image = selectedImage
    }
  }
  
  static let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
  
  let containerView = UIView() <== {
    $0.backgroundColor = .white
  }
  
  let imageView = UIImageView() <== {
    $0.backgroundColor = .red
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
  }
  
  let textView = UITextView() <== {
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
  
  // MARK: - Share & Save
  
  func handleShare() {
    guard let caption = textView.text, caption.characters.count > 0 else { return }
    guard let image = selectedImage else { return }
    guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
    
    navigationItem.rightBarButtonItem?.isEnabled = false
    
    let filename = NSUUID().uuidString
    FIRStorage.storage().reference().child("posts").child(filename).put(uploadData, metadata: nil) { (metadata, err) in
      
      if let err = err {
         self.navigationItem.rightBarButtonItem?.isEnabled = true
        print("Failed to upload post image:", err)
        return
      }
      
      guard let imageURL = metadata?.downloadURL()?.absoluteString else { return }
      print("Successfully uploaded post image:", imageURL)
      
      self.saveToDatabase(with: imageURL)
    }
  }
  
  fileprivate func saveToDatabase(with imageURL: String) {
    guard let postImage = selectedImage else { return }
    guard let caption = textView.text else { return }
    
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }
    let userPostRef = FIRDatabase.database().reference().child("posts").child(uid)
    let ref = userPostRef.childByAutoId()
    let values = ["imageURL": imageURL,
                  "caption": caption,
                  "imageWidth": postImage.size.width,
                  "imageHeight": postImage.size.height,
                  "creationDate": Date().timeIntervalSince1970] as [String: Any]
    
    ref.updateChildValues(values) { (err, ref) in
      if let err = err {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        print("Failed to save post to DB", err)
      }
      
      print("Successfully saved post to DB")
      self.dismiss(animated: true , completion: nil)
      
      NotificationCenter.default.post(name: SharePhotoController.updateFeedNotificationName, object: nil)
    }
  }
  
}

extension SharePhotoController {
  fileprivate func setupImageAndTextViews() {
    view.addSubview(containerView)
    containerView.addSubview(imageView)
    containerView.addSubview(textView)
    
    containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
    
    imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
    
    textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
  }
}
