//
//  AppDelegate.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 4.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import UIKit
import SwiftMessages

enum AlertType {
    case Success, Info, Warning, Error
}

extension UIViewController {
    
    func showCardViewAlert(title: String?, message: String, type: AlertType) {
        
        let messageView = MessageView.viewFromNib(layout: MessageView.Layout.cardView)
        switch type {
        case .Success:
            messageView.configureTheme(.success)
        case .Info:
            messageView.configureTheme(.info)
        case .Warning:
            messageView.configureTheme(.warning)
        case .Error:
            messageView.configureTheme(.error)
        }
        
        messageView.button?.isHidden = true
        messageView.configureContent(title: title ?? "", body: message, iconText: "")
        SwiftMessages.show(view: messageView)
    }
}
