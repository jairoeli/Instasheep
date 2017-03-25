//
//  ViewController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/21/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  // MARK: - Properties
  
  lazy var plusPhotoButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
    return button
  }()
  
  lazy var emailTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Email"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.keyboardType = .emailAddress
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    tf.returnKeyType = .next
    tf.clearButtonMode = .whileEditing
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  lazy var usernameTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Username"
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    tf.returnKeyType = .next
    tf.clearButtonMode = .whileEditing
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  lazy var passwordTextField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Password"
    tf.isSecureTextEntry = true
    tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
    tf.borderStyle = .roundedRect
    tf.font = UIFont.systemFont(ofSize: 14)
    tf.autocapitalizationType = .none
    tf.autocorrectionType = .no
    tf.returnKeyType = .done
    tf.clearButtonMode = .whileEditing
    tf.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
    return tf
  }()
  
  lazy var signUpButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Sign Up", for: .normal)
    button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    button.layer.cornerRadius = 5
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitleColor(.white, for: .normal)
    button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    button.isEnabled = false
    return button
  }()
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.addSubview(plusPhotoButton)
    
    plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
    plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    
    setupInputFields()
  }
  
  // MARK: - Set up
  
  fileprivate func setupInputFields() {
    let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
    stackView.distribution = .fillEqually
    stackView.axis = .vertical
    stackView.spacing = 10
    
    view.addSubview(stackView)
    
    stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    
  }
  
  // MARK: - Firebase User
  func handleSignUp() {
    guard let email = emailTextField.text, email.characters.count > 0 else { return }
    guard let username = usernameTextField.text, username.characters.count > 0 else { return }
    guard let password = passwordTextField.text, password.characters.count > 0 else { return }
    
    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
      
      if let err = error {
        print("Failed to create user:", err)
        return
      }
      print("Successfully created user:", user?.uid ?? "")
      
      guard let image = self.plusPhotoButton.imageView?.image else { return }
      guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
      let filename = NSUUID().uuidString
      
      FIRStorage.storage().reference().child("profile_image").child(filename).put(uploadData, metadata: nil, completion: { (metadata, err) in
        
        if let err = error {
          print("Failed to upload profile image:", err)
          return
        }
        guard let profileImageURL = metadata?.downloadURL()?.absoluteString else { return }
        print("Successfully uploaded profile image:", profileImageURL)
        
        guard let uid = user?.uid else { return }
        let dictionaryValues = ["username": username, "profileImageURL": profileImageURL]
        let values = [uid: dictionaryValues]
        
        FIRDatabase.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, ref) in
          
          if let err = err {
            print("Failed to save user info into db:", err)
            return
          }
          print("Successfully saved user info to db")
          
        })
      })
    })
  }
  
  func handleTextInputChange() {
    let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && usernameTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0
    
    if isFormValid {
      signUpButton.isEnabled = true
      signUpButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
    } else {
      signUpButton.isEnabled = false
      signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    }
    
  }
  
  // MARK: - UIImagePickerController
  func handlePlusPhoto() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    present(imagePickerController, animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    
    if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
      plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
      
    } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
      plusPhotoButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
    }
    
    plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
    plusPhotoButton.layer.masksToBounds = true
    plusPhotoButton.layer.borderColor = UIColor.black.cgColor
    plusPhotoButton.layer.borderWidth = 1
    
    dismiss(animated: true, completion: nil)
  }
  
  
}
