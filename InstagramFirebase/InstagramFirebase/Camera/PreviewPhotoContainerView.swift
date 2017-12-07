//
//  PreviewPhotoContainerView.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/27/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {

  // MARK: - Properties

  let previewImageView = UIImageView() <== {
    $0.backgroundColor = .yellow
  }

  lazy var cancelButton = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "cancel_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
    $0.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
  }

  lazy var saveButton = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "save_shadow").withRenderingMode(.alwaysOriginal), for: .normal)
    $0.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
  }

  lazy var savedLabel = UILabel() <== {
    $0.text = "Saved Successfully"
    $0.textColor = .white
    $0.font = UIFont.boldSystemFont(ofSize: 18)
    $0.numberOfLines = 0
    $0.backgroundColor = UIColor(white: 0, alpha: 0.3)
    $0.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
    $0.center = self.center
    $0.textAlignment = .center
  }

  // MARK: - Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(previewImageView)
    addSubview(cancelButton)
    addSubview(saveButton)

    setupLayout()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Handle actions

  @objc func handleCancel() {
    self.removeFromSuperview()
  }

  @objc func handleSave() {
    print("Handling save...")

    guard let previewImage = previewImageView.image else { return }

    let library = PHPhotoLibrary.shared()

    library.performChanges({

      PHAssetChangeRequest.creationRequestForAsset(from: previewImage)

    }) { [weak self] (_, err) in
      if let err = err {
        print("Failed to save image to photo library:", err)
        return
      }

      print("Successfully saved image to photo library")
      self?.animations()
    }
  }

  fileprivate func animations() {
    DispatchQueue.main.async {

      self.addSubview(self.savedLabel)
      self.savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)

      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { [weak self] in

        self?.savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)

      }, completion: { (_) in
        UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { [weak self] in

          self?.savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
          self?.savedLabel.alpha = 0

        }, completion: { [weak self] (_) in

          self?.savedLabel.removeFromSuperview()

        })
      })
    }
  }

}

// MARK: - Layout
extension PreviewPhotoContainerView {

  fileprivate func setupLayout() {
    previewImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

    cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)

    saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 24, paddingBottom: 24, paddingRight: 0, width: 50, height: 50)
  }

}
