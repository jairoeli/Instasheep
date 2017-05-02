//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/30/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController {

  // MARK: - Properties

  lazy var containerView = UIView() <== {
    $0.backgroundColor = .white
    $0.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
  }

  lazy var submitButton = UIButton(type: .system) <== {
    $0.setTitle("Submit", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    $0.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
  }

  lazy var textField = UITextField() <== {
    $0.placeholder = "Enter Comment"
  }

  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Comments"
    
    collectionView?.backgroundColor = .red
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    tabBarController?.tabBar.isHidden = false
  }

  override var inputAccessoryView: UIView? {
    get {
      containerView.addSubview(submitButton)
      submitButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 0)

      containerView.addSubview(textField)
      textField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

      return containerView
    }
  }

  override var canBecomeFirstResponder: Bool {
    return true
  }

  // MARK: - Handle Submit

  func handleSubmit() {
    print("Handling submit...")
  }
  
}
