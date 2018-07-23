//
//  AppValues.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 6.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import Foundation

struct ApplicaitonValues {
    static let platform = "ios"
    static var notificationToken = ""
    static var versionNumber: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
}
