//
//  AppDelegate.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 4.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications


/// Kullanici gelen bildirime tikladiginda ilgili alana yonlendirmek icin kullanilir.
protocol PushNotificaitonDelegate: class {
    func notificationTapped(_ targetURL: URL)
}

/// MARK: - AppDelegate class
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    weak var pushNotificationDelegate: PushNotificaitonDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.setRootView()
        
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        
        return true
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {} /// Login token burda kontrol edilir
    func applicationWillResignActive(_ application: UIApplication) {}
    func applicationDidEnterBackground(_ application: UIApplication) {}
    func applicationWillEnterForeground(_ application: UIApplication) {}
    func applicationWillTerminate(_ application: UIApplication) {}
    
}

// MARK: - Auxiliary Methods
extension AppDelegate {
    
    /// User token var ise root view main, yoksa login ekranidir.
    fileprivate func setRootView() {
        
        guard let _ = UserValues.loginToken else {
            let destination = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
            self.window?.rootViewController = destination
            return
        }
        
        let mainVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.window?.rootViewController = mainVC
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        ApplicaitonValues.notificationToken = fcmToken
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {

        guard let pageString = userInfo["page"] as? String else {
            return
        }

        let replacingPageString = pageString.replacingOccurrences(of: ".", with: "/")
//        HandledPushValues.pageURLString = replacingPageString

        let targetURLString = Server.URLString.baseURLString + replacingPageString
        guard let targetURL = URL.init(string: targetURLString) else {
            return
        }
        
        self.pushNotificationDelegate?.notificationTapped(targetURL)
    }
    
}



