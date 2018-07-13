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
        setupKeyboardTypeForTextFields()
        
        // FIXME: - buralari sil, test icin ekledik
        self.emailTextField.text = "bf.asilturk@gmail.com"
        self.passwordTextField.text = "658340"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
    }
    
}

// MARK: - Action Buttons
extension LoginViewController {
    
    @IBAction func LoginButtonTouched(_ sender: UIButton) {
        self.validateUserValuesAndLogin()
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
 
    fileprivate func validateUserValuesAndLogin() {
        guard let email = self.emailTextField.text, email != "" else {
            self.showCardAlert(title: nil, message: "Email adresinizi giriniz", type: .Warning)
            return
        }
        
        guard let password = passwordTextField.text, password != "" else {
            self.showCardAlert(title: nil, message: "Şifrenizi giriniz", type: .Warning)
            return
        }
        
        let emailResult = Validator.emailValidate(email)
        let passwordResult = Validator.passwordValidate(password)
        
        if !emailResult.result {
            self.showCardAlert(title: nil, message: emailResult.errorMessage!, type: .Error)
            return
        }
        
        if !passwordResult.result {
            self.showCardAlert(title: nil, message: passwordResult.errorMessage!, type: .Error)
            return
        }
        
        loginProcess(email, password)
    }
    
    fileprivate func loginProcess(_ email: String, _ password: String) {
        
        LoginCoordinator.shared.loginRequest(email, password) { (result, message) in
            if !result {
                self.showCardAlert(title: nil, message: message, type: .Error)
                return
            }
            
            self.showMainView()
        }
        
    }
    
    fileprivate func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    fileprivate func setupKeyboardTypeForTextFields() {
        emailTextField.keyboardType = .emailAddress
    }
    
    
    /// Login islemi basarili olup login token kayit edildikten sonra kullanici webView'a yonlendirilir
    fileprivate func showMainView() {
        let destination = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        self.present(destination, animated: true, completion: nil)
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
