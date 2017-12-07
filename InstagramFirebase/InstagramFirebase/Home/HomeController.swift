//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/7/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, HomePostCellDelegate {

  private let cellId = "cellId"
  var posts = [Post]()

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
    collectionView?.backgroundColor = .white

    collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    collectionView?.refreshControl = refreshControl

    setupNavigationItems()
    fetchAllPosts()
  }

  func setupNavigationItems() {
    navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "logo2"))

    navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
  }

  @objc func handleCamera() {
    let cameraController = CameraController()
    present(cameraController, animated: true, completion: nil)
  }

  @objc func handleRefresh() {
    posts.removeAll()
    fetchAllPosts()
  }

  // MARK: - Notification
  @objc func handleUpdateFeed() {
    handleRefresh()
  }

  // MARK: - Firebase

  fileprivate func fetchAllPosts() {
    fetchPosts()
    fetchFollowingUserIds()
  }

  fileprivate func fetchPosts() {
    guard let uid = Auth.auth().currentUser?.uid else { return }

    Database.fetchUserWith(uid: uid) { (user) in
      self.fetchPostsWith(user: user)
    }

  }

  fileprivate func fetchPostsWith(user: User) {

    let ref = Database.database().reference().child("posts").child(user.uid)
    ref.observeSingleEvent(of: .value, with: { (snapshot) in

      self.collectionView?.refreshControl?.endRefreshing()

      guard let dictionaries = snapshot.value as? [String: Any] else { return }

      dictionaries.forEach({ (key, value) in
        guard let dictionary = value as? [String: Any] else { return }

        var post = Post(user: user, dictionary: dictionary)
        post.id = key

        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("likes").child(key).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in

          if let value = snapshot.value as? Int, value == 1 {
            post.hasLiked = true
          } else {
            post.hasLiked = false
          }

          self.posts.append(post)
          self.posts.sort(by: { (p1, p2) -> Bool in
            return p1.creationDate.compare(p2.creationDate) == .orderedDescending
          })
          self.collectionView?.reloadData()

        }, withCancel: { (err) in
          print("Failed to fetch like info for post:", err)
        })

      })

    }) { (err) in
      print("Failed to fetch posts:", err)
    }
  }

  fileprivate func fetchFollowingUserIds() {
    guard let uid = Auth.auth().currentUser?.uid else { return }
    Database.database().reference().child("Following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in

      guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }

      userIdsDictionary.forEach({ (key, _) in
        Database.fetchUserWith(uid: key, completion: { (user) in
          self.fetchPostsWith(user: user)
        })
      })

    }) { (err) in
      print("Failed to fetch following user ids: ", err)
    }
  }

  // MARK: - Delegate

  func didTapComment(post: Post) {
    print(post.caption)
    let commentsController = CommentsController(collectionViewLayout: UICollectionViewFlowLayout())
    commentsController.post = post
    navigationController?.pushViewController(commentsController, animated: true)
  }

  func didLike(for cell: HomePostCell) {
    guard let indexPath = collectionView?.indexPath(for: cell) else { return }

    var post = self.posts[indexPath.item]
    print(post.caption)

    guard let postID = post.id else { return }
    guard let uid = Auth.auth().currentUser?.uid else { return }

    let values = [uid: post.hasLiked == true ? 0 : 1]
    Database.database().reference().child("likes").child(postID).updateChildValues(values) { (err, _) in
      if let err = err {
        print("Failed to like post:", err)
        return
      }

      print("Successfully liked post.")

      post.hasLiked = !post.hasLiked
      self.posts[indexPath.item] = post
      self.collectionView?.reloadItems(at: [indexPath])
    }
  }

  // MARK: - UICollectionView

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? HomePostCell else { return UICollectionViewCell() }

    cell.post = posts[indexPath.item]
    cell.delegate = self

    return cell
  }

}

// MARK: - UICollectionView Flow Layout
extension HomeController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    var height: CGFloat = 40 + 8 + 8  // username userprofileimageview
    height += view.frame.width
    height += 50
    height += 60

    return CGSize(width: view.frame.width, height: height)
  }

}
