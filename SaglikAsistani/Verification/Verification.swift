//
//  Validator.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 5.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import Foundation

class Verification: NSObject {
    
    static func passwordValidate(_ value:String) -> (result: Bool, errorMessage: String?) {
        guard value.count >= 6 else {
            return (false, "Şifre minimum 6 karakter olmalı")
        }
        return (true, nil)
    }
    
    static func emailValidate(_ value:String) -> (result: Bool, errorMessage: String?) {
        if (value.count < 6) {
            return (false, "Email adresi çok kısa, teknik olarak 6 karakterden daha fazla olmalıdır.")
        }
        
        guard let regexValidator = try? NSRegularExpression(pattern: "[a-zA-Z0-9_+-.]+@[a-zA-Z]+\\.[a-zA-Z]{2,6}", options: .caseInsensitive) else {
            return (false, nil)
        }
        
        guard regexValidator.numberOfMatches(in: value, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, value.count)) > 0  else {
            return (false, "Email adresiniz onaylanmadı, lütfen tekrar kontrol ediniz....")
        }
        
        return (true, nil)
    }
}
