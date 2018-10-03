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
    func notificationTapped(_ targetURLString: String)
}

/// MARK: - AppDelegate class
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    weak var pushNotificationDelegate: PushNotificaitonDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.initializeMethod(application)
        
        return true
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

        guard let pageString = userInfo["page"] as? String else { return }
        let replacingPageString = pageString.replacingOccurrences(of: ".", with: "/")
        let targetURLString = Server.URLString.baseURLString + replacingPageString
        
        // Bildirime tiklandiginda uygulamayi acip ilgili goreve yonlendirir.
        self.pushNotificationDelegate?.notificationTapped(targetURLString)
    }
    
}


// MARK: - Auxiliary Methods
extension AppDelegate {
    
    /// AppDelegate baslatilirken default ayarlari atamada kullanilir.
    fileprivate func initializeMethod(_ application: UIApplication) {
        RootVC.shared.setRootView()
        FirebaseApp.configure()
        
        self.requestNotificaitonPermission(application)
        
        Messaging.messaging().delegate = self
    }
    
    /// Kullanici bildirimleri izni alinir ve push bildirimler acilir.
    fileprivate func requestNotificaitonPermission(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        
        application.registerForRemoteNotifications()
    }
    
    
}
