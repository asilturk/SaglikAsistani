//
//  UserValues.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 10.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import Foundation

struct UserValues {
    
    /// Kullanici login olduktan sonra, session kontrol islemlerinde kullanilmak uzere login token'in hafizada tutulmasi.
    static var loginToken: String {
        get {
            if let token = UserDefaults.standard.value(forKey: "loginToken") as? String {
                return token
            } else {
                return ""
            }
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "loginToken")
            UserDefaults.standard.synchronize()
            
            print("# Login token kayit edildi: \(newValue)")
        }
    }
    
    private init(){}
}
