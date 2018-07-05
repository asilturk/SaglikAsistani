//
//  ViewController.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 4.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var singInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.setupButtonsProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
    }
    
}

// MARK: - Action Buttons
extension LoginViewController {
    
    @IBAction func signInButtonTouched(_ sender: UIButton) {
        self.emailVerification(email: self.emailTextField.text)
        self.hideKeyboard()
    }
    
    @IBAction func signUpButtonTouched(_ sender: UIButton) {
        self.hideKeyboard()
    }
    
    @IBAction func forgotPasswordButtonTouched(_ sender: UIButton) {
    }
    
    
}

// MARK: - Auxiliary Methods
extension LoginViewController {
    fileprivate func setupButtonsProperties() {
        let borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        
        self.singInButton.layer.borderWidth = 0.5
        self.signUpButton.layer.borderWidth = 0.5
        self.singInButton.layer.borderColor = borderColor
        self.signUpButton.layer.borderColor = borderColor
        self.singInButton.layer.cornerRadius = 4.0
        self.signUpButton.layer.cornerRadius = 4.0
    }
    
    fileprivate func emailVerification(email: String?) {
        guard let email = email, email != "" else {
            self.showCardViewAlert(title: nil, message: "Email alanı boş bırakılamaz", type: .Error)
            return
        }
        
        let (result, message) = Validator.emailValidate(email)
        
        if message != nil {
            self.showCardViewAlert(title: nil, message: message!, type: .Error)
            return
        }
        
        self.passwordVerification(password: self.passwordTextField.text)
    }
    
    fileprivate func passwordVerification(password: String?) {
        guard let password = password, password != "" else {
            self.showCardViewAlert(title: nil, message: "Şifre alanı boş bırakılamaz", type: .Error)
            return
        }
        
        let (result, message) = Validator.passwordValidate(password)
        
        if message != nil {
            self.showCardViewAlert(title: nil, message: message!, type: .Error)
            return
        }
        
    }
    
    fileprivate func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Hide Keyboard
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    fileprivate func hideKeyboard() {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
}
