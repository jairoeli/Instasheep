//
//  CameraController.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 4/25/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController {
  
  lazy var dismissButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "right_arrow_shadow"), for: .normal)
    button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
    return button
  }()
  
  lazy var capturePhotoButton: UIButton =  {
    let button = UIButton(type: .system)
    button.setImage(#imageLiteral(resourceName: "capture_photo"), for: .normal)
    button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCaptureSession()
    setupHUD()
  }
  
  // MARK: - Handle
  
  func handleCapturePhoto() {
    print("Capturing photo...")
  }
  
  func handleDismiss() {
    dismiss(animated: true, completion: nil)
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
    let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
    
    do {
        let input = try AVCaptureDeviceInput(device: captureDevice)
        if captureSession.canAddInput(input) {
          captureSession.addInput(input)
      }
    } catch let err {
        print("Could not setup camera input:", err)
    }
    
    // 2. setup outputs
    let output = AVCapturePhotoOutput()
    if captureSession.canAddOutput(output) {
        captureSession.addOutput(output)
    }
    
    // 3. setup output preview
    guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else { return }
    previewLayer.frame = view.frame
    view.layer.addSublayer(previewLayer)
    
    captureSession.startRunning()
  }
  
}
