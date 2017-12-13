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

  lazy var plusPhotoButton = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
    $0.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
  }

  lazy var emailTextField = UITextField() <== {
    $0.placeholder = "Email"
    $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
    $0.borderStyle = .roundedRect
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.keyboardType = .emailAddress
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.returnKeyType = .next
    $0.clearButtonMode = .whileEditing
    $0.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
  }

  lazy var usernameTextField = UITextField() <== {
    $0.placeholder = "Username"
    $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
    $0.borderStyle = .roundedRect
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.returnKeyType = .next
    $0.clearButtonMode = .whileEditing
    $0.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
  }

  lazy var passwordTextField = UITextField() <== {
    $0.placeholder = "Password"
    $0.isSecureTextEntry = true
    $0.backgroundColor = UIColor(white: 0, alpha: 0.03)
    $0.borderStyle = .roundedRect
    $0.font = UIFont.systemFont(ofSize: 14)
    $0.autocapitalizationType = .none
    $0.autocorrectionType = .no
    $0.returnKeyType = .done
    $0.clearButtonMode = .whileEditing
    $0.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
  }

  lazy var signUpButton = UIButton(type: .system) <== {
    $0.setTitle("Sign Up", for: .normal)
    $0.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    $0.layer.cornerRadius = 5
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    $0.setTitleColor(.white, for: .normal)
    $0.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
    $0.isEnabled = false
  }

  lazy var alreadyHaveAccountButton = UIButton(type: .system) <== {
    let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray])

    attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.rgb(red: 17, green: 154, blue: 237)]))

    $0.setAttributedTitle(attributedTitle, for: .normal)
    $0.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white

    view.addSubview(plusPhotoButton)
    view.addSubview(alreadyHaveAccountButton)

    setupLayout()
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

  fileprivate func setupLayout() {
    plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
    plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
  }

  // MARK: - Handle Login
  @objc func handleAlreadyHaveAccount() {
    _ = navigationController?.popViewController(animated: true)
  }

  // MARK: - Firebase User
  @objc func handleSignUp() {
    guard let email = emailTextField.text, email.count > 0 else { return }
    guard let username = usernameTextField.text, username.count > 0 else { return }
    guard let password = passwordTextField.text, password.count > 0 else { return }

    Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error: Error?) in

      if let err = error {
        print("Failed to create user:", err)
        return
      }
      print("Successfully created user:", user?.uid ?? "")

      guard let image = self.plusPhotoButton.imageView?.image else { return }
      guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
      let filename = NSUUID().uuidString

      Storage.storage().reference().child("profile_image").child(filename).putData(uploadData, metadata: nil, completion: { (metadata, err) in

        if let err = error {
          print("Failed to upload profile image:", err)
          return
        }
        guard let profileImageURL = metadata?.downloadURL()?.absoluteString else { return }
        print("Successfully uploaded profile image:", profileImageURL)

        guard let uid = user?.uid else { return }
        guard let fcmToken = Messaging.messaging().fcmToken else { return }

        let dictionaryValues = ["username": username, "profileImageURL": profileImageURL, "fcmToken": fcmToken]
        let values = [uid: dictionaryValues]

        Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (err, _) in

          if let err = err {
            print("Failed to save user info into db:", err)
            return
          }
          print("Successfully saved user info to db")

          guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
          mainTabBarController.setupViewControllers()

          self.dismiss(animated: true, completion: nil)
        })
      })
    })
  }

  @objc func handleTextInputChange() {
    let isFormValid = emailTextField.text?.count ?? 0 > 0 && usernameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0

    if isFormValid {
      signUpButton.isEnabled = true
      signUpButton.backgroundColor = .mainBlue()
    } else {
      signUpButton.isEnabled = false
      signUpButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    }

  }

  // MARK: - UIImagePickerController
  @objc func handlePlusPhoto() {
    let imagePickerController = UIImagePickerController()
    imagePickerController.delegate = self
    imagePickerController.allowsEditing = true
    present(imagePickerController, animated: true, completion: nil)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

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
