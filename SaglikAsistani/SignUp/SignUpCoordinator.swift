//
//  SignUpCoordinator.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 6.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import Foundation

class SignUpCoordinator {
    static var shared = SignUpCoordinator()
    private init() {}
}

// MARK: - SignUp Request
extension SignUpCoordinator {
    
    func signUpRequest(firmId: Int,
                       name: String,
                       email: String,
                       phoneNumber: String,
                       height: String,
                       weight: String,
                       birthday: String,
                       gender: String,
                       completion: @escaping (Bool, String) -> Void) {
        
        var request = URLRequest.init(url: Server.registerURL!)
        var postString = ""
        postString += "firm_id=\(firmId)" 
        postString += "&isim=\(name)"
        postString += "&email=\(email)"
        postString += "&ceptel=\(phoneNumber)"
        postString += "&kilo=\(weight)"
        postString += "&boy=\(height)"
        postString += "&dogum=\(birthday)"
        postString += "&cinsiyet=\(gender)"
        postString += "&ios_notify_token=\(ApplicaitonValues.notificationToken)"
        postString += "&android_notify_token=NO_VALUE"
        postString += "&platform=\(ApplicaitonValues.platform)"
        postString += "&versiyon=\(ApplicaitonValues.versionNumber)"
        
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(false, error?.localizedDescription ?? "Sorun oluştu, daha sonra tekrar deneyin.")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                print("response = \(response)")
                let error = NSError.init(domain: "Server hata kodu: \(httpStatus.statusCode). Lüften daha sonra deneyin.", code: 0, userInfo: nil)
                completion(false, error.localizedDescription)
            }
        
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(responseString)")
            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] else {
                    completion(false, "Server iletişim hatası, uygulama sahibiyle iletişime geçin.")
                    return
                }
                
                guard let status = json["status"] as? Int else { return }
                
                if status == 0 {
                    let errorMessage = json["message"] as! String
                    completion(false, errorMessage)
                    return
                }
                
                if status == 1 {
                    print("success")
                    completion(true, "")
                }
                
            } catch let error as NSError {
                print(error)
                completion(false, error.localizedDescription)
            }
        }
        
        task.resume()
    }
}
