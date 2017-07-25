//
//  UserProfileController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/22/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController {

  // MARK: - Properties

  fileprivate let headerID = "headerId"
  fileprivate let cellId = "cellId"
  fileprivate let homePostCellID = "homePostCellID"
  var user: User?
  var posts = [Post]()
  var userID: String?
  var isFinishedPaging = false
  var isGridView = true

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    collectionView?.backgroundColor = .white
    collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerID)
    collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: cellId)
    collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellID)

    setupLogOutButton()
    fetchUser()
//    fetchOrderedPosts()
  }

  // MARK: - Fetch User & Post
  fileprivate func fetchOrderedPosts() {
    guard let uid = self.user?.uid else { return }
    let ref = FIRDatabase.database().reference().child("posts").child(uid)

    // perhaps later on we'll implement some pagination of data
    ref.queryOrdered(byChild: "creationDate").observe(.childAdded, with: { (snapshot) in

      guard let dictionary = snapshot.value as? [String: Any] else { return }
      guard let user = self.user else { return }

      let post = Post(user: user, dictionary: dictionary)
      self.posts.insert(post, at: 0)
//      self.posts.append(post)

      self.collectionView?.reloadData()

    }) { (err) in
      print("Failed to fetch ordered posts:", err)
    }
  }

  fileprivate func fetchUser() {
    let uid = userID ?? (FIRAuth.auth()?.currentUser?.uid ?? "")
    //guard let uid = FIRAuth.auth()?.currentUser?.uid else { return }

    FIRDatabase.fetchUserWith(uid: uid) { (user) in
      self.user = user
      self.navigationItem.title = self.user?.username
      self.collectionView?.reloadData()
      self.paginatePosts()
    }

  }

  // MARK: - Pagination

  fileprivate func paginatePosts() {
    print("Start paging for more posts")
    guard let uid = self.user?.uid else { return }
    let ref = FIRDatabase.database().reference().child("posts").child(uid)

    var query = ref.queryOrderedByKey()

    if posts.count > 0 {
      let value = posts.last?.id
      query = query.queryStarting(atValue: value)
    }

    query.queryLimited(toFirst: 4).observeSingleEvent(of: .value, with: { (snapshot) in

      guard var allObjects = snapshot.children.allObjects as? [FIRDataSnapshot] else { return }

      if allObjects.count < 4 {
        self.isFinishedPaging = true
      }

      if self.posts.count > 0 {
        allObjects.removeFirst()
      }

      guard let user = self.user else { return }

      allObjects.forEach({ (snapshot) in
        guard let dictionary = snapshot.value as? [String: Any] else { return }
        var post = Post(user: user, dictionary: dictionary)
        post.id = snapshot.key
        self.posts.append(post)
//        print(snapshot.key)
      })

      self.posts.forEach({ (post) in
        print(post.id ?? "")
      })

      self.collectionView?.reloadData()

    }) { (err) in
      print("Failed to paginate for posts:", err)
    }
  }

  // MARK: - Log out

  fileprivate func setupLogOutButton() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
  }

  func handleLogOut() {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

    alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in

      do {
        try FIRAuth.auth()?.signOut()

        // what happens? we need to present some kind of login controller 
        let loginController = LoginController()
        let navController = UINavigationController(rootViewController: loginController)
        self.present(navController, animated: true, completion: nil)

      } catch let signOutError {
        print("Failed to sign out:", signOutError)
      }

    }))

    alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    present(alertController, animated: true, completion: nil)
  }

  // MARK: - Collectin View data source
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return posts.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    // fire off the paginate cell
    if indexPath.item == self.posts.count - 1 && isFinishedPaging {
      print("Paginating for posts")
      paginatePosts()
    }

    if isGridView {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? UserProfilePhotoCell else { return UICollectionViewCell() }
      cell.post = posts[indexPath.item]
      return cell
    } else {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellID, for: indexPath) as? HomePostCell else { return UICollectionViewCell() }
      cell.post = posts[indexPath.item]
      return cell
    }

  }

}

  // MARK: - Collection View Flow Layout
extension UserProfileController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    if isGridView {
      let width = (view.frame.width - 2) / 3
      return CGSize(width: width, height: width)
    } else {
      var height: CGFloat = 40 + 8 + 8  // username userprofileimageview
      height += view.frame.width
      height += 50
      height += 60

      return CGSize(width: view.frame.width, height: height)
    }

  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 1
  }

  // MARK: - Header
  override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as? UserProfileHeader else { return UICollectionViewCell() }

    header.user = self.user
    header.delegate = self

    return header
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: view.frame.height, height: 200)
  }
}

// MARK: - Grid & List
extension UserProfileController: UserProfileHeaderDelegate {

  func didChangeToGridView() {
    isGridView = true
    collectionView?.reloadData()
  }

  func didChangeToListView() {
    isGridView = false
    collectionView?.reloadData()
  }

}
