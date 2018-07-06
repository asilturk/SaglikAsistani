//
//  LoginCoordinator.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 6.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import Foundation

class LoginCoordinator {
    static let shared = LoginCoordinator()
    private init() { }
}

// MARK: - Login Request
extension LoginCoordinator {
    
    func loginRequest(_ email: String, _ password: String) {
        var request = URLRequest.init(url: Server.loginURL!)
        let postString = "email" + "=" + email + "&" + "password" + "=" + password
        
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {                                                 // check for 
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(responseString)")
            
        }
        task.resume()
        
    }
}
