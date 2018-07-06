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
    
    func signUpRequest(firmId: Int, name: String, email: String, phoneNumber: String, height: String, weight: String, birthday: String, gender: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest.init(url: Server.registerURL!)
        
        var postString = "firm_id=\(firmId)"
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
                print("error=\(error)")
                completion(false, NSError.init(domain: error?.localizedDescription ?? "", code: 0, userInfo: nil))
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            
            completion(true, nil)
//            let responseString = String(data: data, encoding: .utf8)
//            print("responseString = \(responseString)")
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                let posts = json["posts"] as? [[String: Any]] ?? []
                
                print(posts)
            } catch let error as NSError {
                print(error)
            }

        }
        task.resume()
        
    }
}
