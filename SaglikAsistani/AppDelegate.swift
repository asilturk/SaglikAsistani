//
//  AppDelegate.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 4.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.setRootView()
        
        return true
    }
    
    /// Login token burda kontrol edilir
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
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
