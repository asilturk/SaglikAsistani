//
//  RootVC.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 3.10.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import UIKit

class RootVC {
    
    static let shared = RootVC()
    private init () {}

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
}

// MARK: - Auxiliary Methods
extension RootVC {
    
    /// User token var ise root view main, yoksa login ekranidir.
    func setRootView() {
        
        guard let _ = UserValues.loginToken else {
            self.appDelegate.window?.rootViewController = Destination().LoginVC
            return
        }
        
        self.appDelegate.window?.rootViewController = Destination().MainVC
    }
    

}

