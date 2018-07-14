//
//  Networking.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 6.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import Foundation

struct Server {
    static let loginURL = URL.init(string: "http://uygulama.planpiri.com/mobil/user_login")
    static let resetPasswordURL = URL.init(string: "http://uygulama.planpiri.com/mobil/reset_password")
    static let registerURL = URL.init(string: "http://uygulama.planpiri.com/mobil/user_register")
    static let sessionControlURL = URL.init(string: "http://uygulama.planpiri.com/mobil/user_control")
    
    private init() {}
}

// MARK: - Auxiliary Methods
extension Server {
    
    static func resetUserPassword(email: String, completion: @escaping(Bool, String) -> Void) {
        var request = URLRequest.init(url: Server.resetPasswordURL!)
        let postString = "email=\(email)"
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(false, error?.localizedDescription ?? "Bir sorun oluştu, daha sonra tekrar deneyin")
                //                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completion(false, "Bir sorunumuz var, hata kodu:\(httpStatus.statusCode).")
            }
            
            // TODO: Veriler parse edilecek, kullanici bilgilendirilecek
            
        }
        task.resume()
    }
    
    static func controlUserSession(userId: String, loginToken: String, completion: @escaping(Bool, String) -> Void) {
        var request = URLRequest.init(url: Server.sessionControlURL!)
        var postString = ""
        
        postString += "user_id=\(userId)"
        postString += "&login_token=\(loginToken)"
        postString += "&ios_notify_token=\(ApplicaitonValues.notificationToken)"
        postString += "&platform=\(ApplicaitonValues.platform)"
        postString += "&versiyon=\(ApplicaitonValues.versionNumber)"
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(false, error?.localizedDescription ?? "Bir sorun oluştu, daha sonra tekrar deneyin")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completion(false, "Bir sorunumuz var, hata kodu:\(httpStatus.statusCode).")
                return
            }
            
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! NSDictionary else {
                completion(false, "")
                return
            }
            
            let status = json["status"] as! Bool
            let message = json["message"] as! String
        
            completion(status, message)
            
        }
        task.resume()
    }
}
