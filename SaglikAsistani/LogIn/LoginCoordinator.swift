//
//  LoginCoordinator.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 6.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import Foundation

// FIXME: - Login sonrasi  password = 658340; geliyor, bunun gelmemesi lazim diye dusunuyorum.
// Birthday gonderirken format onemli, yanlis gidiyor. buna bir bakmaliyiz.

class LoginCoordinator {
    static let shared = LoginCoordinator()
    private init() { }
}


// MARK: - Login Request
extension LoginCoordinator {
    
    func loginRequest(_ email: String, _ password: String, completion: @escaping (Bool, String) -> Void) {
        var request = URLRequest.init(url: Server.loginURL!)
        var postString = ""
        
        postString += "email=\(email)"
        postString += "&sifre=\(password)"
        postString += "&ios_notify_token=\(ApplicaitonValues.notificationToken)"
        postString += "&platform=\(ApplicaitonValues.platform)"
        postString += "&versiyon=\(ApplicaitonValues.versionNumber)"
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {                                 
                print("error: \(error?.localizedDescription ?? "")")
                completion(false, error?.localizedDescription ?? "")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completion(false, "Server error. StatusCode should be 200, but is: \(httpStatus.statusCode)")
            }
            
            guard  let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: Any] else {
                completion(false, "Login işlemi başarısız.")
                return
            }
            
            
            guard let status = json["status"] as? Int  else { return }
            guard let unsuccessfulLoginMessage = json["message"] as? String  else { return }
            
            if status != 1 { completion(false, unsuccessfulLoginMessage) }
            
            guard let retrievedData = (json["data"] as? [Any])?[0] as? [String: Any] else {
                completion(false, "Json veriler parse edilemedi.")
                return
            }
            
            guard let loginToken = retrievedData["login_token"] as? String else {
                completion(false, "Login token alınamadı")
                return
            }
            
            UserValues.loginToken = loginToken
            completion(true, "")
            
            }.resume()
        
    }
}
