//
//  Destination.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 3.10.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import UIKit

private class _Storyboard {
    static let Login = UIStoryboard.init(name: "Login", bundle: nil)
    static let Main = UIStoryboard.init(name: "Main", bundle: nil)
    
    private init() {}
}

class Destination {
    let MainVC = _Storyboard.Main.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
    let LoginVC = _Storyboard.Login.instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
}
