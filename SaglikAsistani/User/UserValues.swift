//
//  UserValues.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 10.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import Foundation

struct UserValues {
    
    private init() {}
    
    /// Kullanici login olduktan sonra, session kontrol islemlerinde kullanilmak uzere login token'in hafizada tutulmasi.
    static var loginToken: String? {
        get {
            return UserDefaults.standard.value(forKey: "loginToken") as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "loginToken")
            UserDefaults.standard.synchronize()
        }
    }
    
    /// Login olan kullanici id'si
    static var userId: String? {
        get {
            return UserDefaults.standard.value(forKey: "userId") as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "userId")
            UserDefaults.standard.synchronize()
        }
    }
    
}





