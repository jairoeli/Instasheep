//
//  CommentsController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/30/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController {

  // MARK: - Properties

  var post: Post?
  let cellID = "cellId"
  var comments = [Comment]()

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

  lazy var commentTextField = UITextField() <== {
    $0.placeholder = "Enter Comment"
  }

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = "Comments"

    collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
    collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)

    collectionView?.backgroundColor = .red
    collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: cellID)

    fetchComments()
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

      containerView.addSubview(commentTextField)
      commentTextField.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

      return containerView
    }
  }

  override var canBecomeFirstResponder: Bool {
    return true
  }

  // MARK: - Fetch comments
  fileprivate func fetchComments() {
    guard let postID = self.post?.id else { return }
    let ref = FIRDatabase.database().reference().child("comments").child(postID)

    ref.observe(.childAdded, with: { (snapshot) in

      guard let dictionary = snapshot.value as? [String: Any] else { return }

      let comment = Comment(dictionary: dictionary)
//      print(comment.text, comment.uid)
      self.comments.append(comment)
      self.collectionView?.reloadData()

    }) { (_) in
      print("Failed to observe comments")
    }
  }

  // MARK: - Handle Submit

  func handleSubmit() {
    guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }

    print("post id:", self.post?.id ?? "")
    print("Inserting comment:", commentTextField.text ?? "")

    let postID = self.post?.id ?? ""
    let values = ["text": commentTextField.text ?? "", "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]

    FIRDatabase.database().reference().child("comments").child(postID).childByAutoId().updateChildValues(values) { (err, _) in

      if let err = err {
        print("Failed to insert comment:", err)
      }

      print("Successfully inserted comment")
    }
  }

}

extension CommentsController: UICollectionViewDelegateFlowLayout {

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return comments.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? CommentCell else { return UICollectionViewCell() }

    cell.comment = self.comments[indexPath.item]

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 50)
  }

}
