//
//  DeviceType.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 3.10.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import UIKit

extension UIDevice {
    
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    
    var iphoneXS: Bool {
        return iPhoneX
    }
    
    var iphoneXSMax: Bool {
        return UIScreen.main.nativeBounds.height == 2688
    }
    
    var iphoneXR: Bool {
        return UIScreen.main.nativeBounds.height == 1792
    }

}
