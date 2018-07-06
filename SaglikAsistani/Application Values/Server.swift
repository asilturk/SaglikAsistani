//
//  Networking.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 6.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import Foundation

struct Server {
    static let loginURL = URL.init(string: "http://takvim.derindata.com/mobil/user_login")
    static let resetPasswordURL = URL.init(string: "http://takvim.derindata.com/mobil/reset_password")
    static let registerURL = URL.init(string: "http://takvim.derindata.com/mobil/user_register")
    static let userControlURL = URL.init(string: "http://takvim.derindata.com/mobil/user_control")
    
    private init() {}
}
