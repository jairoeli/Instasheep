//
//  AppDelegate.swift
//  InstagramFirebase
//
//  Created by Jairo Eli de Leon on 3/21/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()

    window = UIWindow()
    window?.rootViewController = MainTabBarController()

    attemtpRegisterForNotifications(application: application)

    return true
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("Registered for notifications:", deviceToken)
  }

  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    print("Registered with FCM with token:", fcmToken)
  }

  // list for user notificaitons
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler(.alert)
  }

  private func attemtpRegisterForNotifications(application: UIApplication) {
    print("Ateempting to register APNS...")

    Messaging.messaging().delegate = self

    UNUserNotificationCenter.current().delegate = self

    // user notifications auth
    // all of this works for iOS 10+
    let options: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: options) { (granted, err) in
      if let err = err {
        print("Failed to request auth:", err)
        return
      }

      if granted {
        print("Auth granted.")
      } else {
        print("Auth denied.")
      }
    }

    application.registerForRemoteNotifications()
  }

}
