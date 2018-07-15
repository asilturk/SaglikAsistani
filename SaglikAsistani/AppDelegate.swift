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
        
        self.toggleRootView(inManual: false)
        
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
    
    /// User login olduktan sonra gosterilecek ekranin belirlenmesinde kullanilir.
    ///
    /// - Parameter inManual: login_token degeri gecerliligini yitirdiginde tekrar login olmasi icin true gonderilr.
    fileprivate func toggleRootView(inManual: Bool) {
        
        let defaultViewController = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
        
        if inManual {
            self.window?.rootViewController = defaultViewController
        } else {
            
            /// Remember user login and set root.
            if let loginToken = UserValues.loginToken, loginToken != "" {
                let destination = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
                self.window?.rootViewController = destination
            } else {
                self.window?.rootViewController = defaultViewController
            }
        }
    }
    
    /// Login token araciligiyla session'in kontrol edilmesi, alinan token mevcuttan farkliysa login ekranina yonelndirilir
    ///
    /// - Returns: token yenilendiginde true deger donerek webView'in yenilenmesinde kullanilir.
    fileprivate func loginTokenRegenerated() -> Bool {
        
        Server.controlUserSession(userId: UserValues.userId!,
                                  loginToken: UserValues.loginToken!)
        { (result, message) in
            if !result {
                // TODO: - Login ekranina yonlendirecez
                print("ERROR in loginTokenRegenerated() : \(message)");
                return
            }
            
        }
        return false
    }
}

