//
//  ActivityIndicator.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 14.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {
    
    func blockAnimation(show: Bool, message: String?) {
        
        if !show { self.stopAnimating(); return }
        
        self.startAnimating(nil, message: message,
                            messageFont: UIFont(name: "System", size: 14),
                            type: .ballRotateChase,
                            color: UIColor.white,
                            padding: 0,
                            displayTimeThreshold: 0,
                            minimumDisplayTime: 3,
                            backgroundColor: UIColor.black.withAlphaComponent(0.65),
                            textColor: .white)
    }
    
    
}
