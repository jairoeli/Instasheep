//
//  LoginController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/25/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

  // MARK: - Properties

  let logoContainerView = UIView() <== {
    $0.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
  }

  let logoImageView = UIImageView() <== {
    $0.image = #imageLiteral(resourceName: "Instagram_logo_white")
    $0.contentMode = .scaleAspectFill
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

  lazy var loginButton = UIButton(type: .system) <== {
    $0.setTitle("Login", for: .normal)
    $0.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    $0.layer.cornerRadius = 5
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    $0.setTitleColor(.white, for: .normal)
    $0.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
    $0.isEnabled = false
  }

  lazy var dontHaveAccountButton = UIButton(type: .system) <== {
    let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])

    attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.rgb(red: 17, green: 154, blue: 237)]))

    $0.setAttributedTitle(attributedTitle, for: .normal)
    $0.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
  }

  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.isNavigationBarHidden = true
    view.backgroundColor = .white

    view.addSubview(logoContainerView)
    view.addSubview(dontHaveAccountButton)
    logoContainerView.addSubview(logoImageView)

    setupLayout()
    setupInputFields()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

}

extension LoginController {

  // MARK: - Log In
  func handleShowSignUp() {
    let signUpController = SignUpController()
    navigationController?.pushViewController(signUpController, animated: true)
  }

  func handleTextInputChange() {
    let isFormValid = emailTextField.text?.characters.count ?? 0 > 0 && passwordTextField.text?.characters.count ?? 0 > 0

    if isFormValid {
      loginButton.isEnabled = true
      loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
    } else {
      loginButton.isEnabled = false
      loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
    }

  }

  func handleLogin() {
    guard let email = emailTextField.text else { return }
    guard let password = passwordTextField.text else { return }
    FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, err) in

      if let err = err {
        print("Failed to sign in with email:", err)
        return
      }

      print("Successfully logged back in with user:", user?.uid ?? "")

      guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
      mainTabBarController.setupViewControllers()

      self.dismiss(animated: true, completion: nil)
    })
  }

  // MARK: - Set up
  fileprivate func setupLayout() {
    logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)

    dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)

    logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
    logoImageView.centerXAnchor.constraint(equalTo: logoContainerView.centerXAnchor).isActive = true
    logoImageView.centerYAnchor.constraint(equalTo: logoContainerView.centerYAnchor).isActive = true
  }

  fileprivate func setupInputFields() {
    let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])

    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.distribution = .fillEqually

    view.addSubview(stackView)
    stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
  }
}
