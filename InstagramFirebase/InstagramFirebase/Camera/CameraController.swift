//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/25/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {

  // MARK: - Properties

  let output = AVCapturePhotoOutput()

  let customAnimationPresentor = CustomAnimationPresenter()
  let customAnimationDismisser = CustomAnimationDismisser()

  lazy var dismissButton = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
    $0.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
  }

  lazy var capturePhotoButton = UIButton(type: .system) <== {
    $0.setImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
    $0.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
  }

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    transitioningDelegate = self

    setupCaptureSession()
    setupHUD()
  }

  func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return customAnimationPresentor
  }

  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return customAnimationDismisser
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  @objc func handleDismiss() {
    dismiss(animated: true, completion: nil)
  }

  // MARK: - Capture Photo

  @objc func handleCapturePhoto() {
    print("Capturing photo...")

    let settings = AVCapturePhotoSettings()
    guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
    settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]

    output.capturePhoto(with: settings, delegate: self)
  }

  func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

    let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)

    let previewImage = UIImage(data: imageData!)

    let containerView = PreviewPhotoContainerView()
    containerView.previewImageView.image = previewImage
    view.addSubview(containerView)
    containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
  }

  // MARK: - setup

  fileprivate func setupHUD() {
    view.addSubview(capturePhotoButton)
    view.addSubview(dismissButton)

    capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 24, paddingRight: 0, width: 80, height: 80)
    capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 12, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
  }

  fileprivate func setupCaptureSession() {
    let captureSession = AVCaptureSession()

    // 1. setup inputs
    let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)

    do {
        let input = try AVCaptureDeviceInput(device: captureDevice!)
        if captureSession.canAddInput(input) {
          captureSession.addInput(input)
      }
    } catch let err {
        print("Could not setup camera input:", err)
    }

    // 2. setup outputs
    if captureSession.canAddOutput(output) {
        captureSession.addOutput(output)
    }

    // 3. setup output preview
    let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    previewLayer.frame = view.frame
    view.layer.addSublayer(previewLayer)

    captureSession.startRunning()
  }

}
