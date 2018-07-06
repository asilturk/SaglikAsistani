//
//  AppValues.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 6.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import Foundation

struct ApplicaitonValues {
    // TODO: Buraya firebase token ve app version number eklenecek
    static let platform = "ios"
    static var notificationToken = "xxx"
    static var versionNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    
    private init() {}
}
