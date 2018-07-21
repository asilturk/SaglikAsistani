//
//  SignUp.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 5.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import UIKit
import SwiftMessages

// TODO: telefon 05 ile baslamasini saglayacak kontroller yazilmali

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var heighTextField: UITextField!
    @IBOutlet weak var userAgreementButton: UIButton!
    
    var datePicker: UIDatePicker!
    var gender: String?
    
    // kullanici sozlesmesine izin verilip verilmedigini kontrol eder
    lazy var approved: Bool = {
        return false
    }()
    
    lazy var dateFormatter: DateFormatter? = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupKeyboardTypeForTextFields()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showNavigationBar()
    }
}

// MARK: - Actions
extension SignUpViewController {
    @IBAction func userAgreementButtonTouched() {
        self.approved = !approved
        
        if approved {
            self.userAgreementButton.setImage(#imageLiteral(resourceName: "approved-icon"), for: .normal)
        } else {
            self.userAgreementButton.setImage(#imageLiteral(resourceName: "non-approved-icon"), for: .normal)
        }
    }

    /// Her bir alan icin kontrolleri gerceklestirir
    @IBAction func signUpButtonTouched() {
        self.signUpProcess()
    }
    
    @IBAction func genderTouched(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { self.gender = "Erkek" } else { self.gender = "Kadın"}
    }

}

// MARK: - Auxiliary Methods
extension SignUpViewController {
    
    fileprivate func showNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    fileprivate func setupKeyboardTypeForTextFields() {
        emailTextField.keyboardType = .emailAddress
        phoneTextField.keyboardType = .numberPad
        weightTextField.keyboardType = .numberPad
        heighTextField.keyboardType = .numberPad
    }
    
    fileprivate func showSuccessAlert() {
        let alert = UIAlertController(title: "Kayıt başarılı", message: "Lütfen eposta adresinizi onaylamak için mailinizi kontrol edin", preferredStyle: .alert)
        let action = UIAlertAction(title: "Tamam", style: .default, handler: { (_) in
            self.navigationController?.popViewController(animated: true)
        })
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func signUpProcess() {
        // dogrulamalar
        if !self.nameFormatValidated() { return }
        if !self.emailFormatValidated() { return }
        if !self.phoneNumberValidated() { return }
        if !self.genderValidated().selected { return }
        if !self.userBirthdaySelected() { return }
        if !self.weightFormatValidated() { return }
        if !self.heightFormatValidated() { return }
        if !self.userAgreementValidated() { return }
        
        self.blockAnimation(show: true, message: nil)
        
        // giris islemleri
        SignUpCoordinator.shared.signUpRequest(firmId: 1,
                                               name: self.nameTextField.text ?? "",
                                               email: self.emailTextField.text ?? "",
                                               phoneNumber: self.phoneTextField.text ?? "",
                                               height: self.heighTextField.text ?? "",
                                               weight: self.weightTextField.text ?? "",
                                               birthday: self.birthdayTextField.text ?? "",
                                               gender: self.gender ?? "",
                                               completion:
            { (success, errorMessage) in
                success ? self.showSuccessAlert() : self.showCardAlert(title: "Bir sorunumuz var", message: errorMessage, type: .Error)
                
                self.blockAnimation(show: false, message: nil)
        })
    }
    
}

// MARK: - Validations
extension SignUpViewController {
    
    fileprivate func nameFormatValidated() -> Bool {
        guard let fullName = nameTextField.text, fullName != "" else {
            self.showCardAlert(title: nil, message: "İsim soyisim giriniz", type: .Warning)
            return false
        }
        
        let result = Validator.nameValidate(text: fullName)
        
        if !result {
            self.showCardAlert(title: "İsim soyisim eksik girildi", message: "Lütfen isim ve soyisim giriniz", type: .Warning)
            return false
        }
        
        return true
    }
    
    fileprivate func emailFormatValidated() -> Bool {
        guard let email = emailTextField.text, email != "" else {
            self.showCardAlert(title: nil, message: "Email alanı boş bırakılamaz.", type: .Error)
            return false
        }
        
        let result = Validator.emailValidate(email)
        
        if result.errorMessage != nil {
            self.showCardAlert(title: nil, message: result.errorMessage!, type: .Error)
            return false
        }
        
        return true
    }
    
    fileprivate func phoneNumberValidated() -> Bool {
        guard let phoneNumber = self.phoneTextField.text, phoneNumber != "" else {
            self.showCardAlert(title: nil, message: "Telefon numarası boş bırakılamaz", type: .Warning)
            return false
        }
        
//        if !Validator.numberValidate(phoneNumber) || phoneNumber.count != 11 {
//            self.showCardAlert(title: nil, message: "Telefon numarası 11 haneli rakam olmalıdır", type: .Warning)
//            return false
//        }
        
        return true
    }
    
    fileprivate func weightFormatValidated() -> Bool {
        guard let weight = weightTextField.text, weight != "" else {
            self.showCardAlert(title: nil, message: "Kilonuzu giriniz", type: .Error)
            return false
        }
        
        if !(weight.count == 2 || weight.count == 3) {
            self.showCardAlert(title: nil, message: "Kilonuzu kontrol edin", type: .Warning)
            return false
        }
        
        if !Validator.numberValidate(weight) {
            self.showCardAlert(title: nil, message: "Kilonuz sayısal değer olmalı", type: .Error)
            return false
        }
        
        return true
    }
    
    fileprivate func heightFormatValidated() -> Bool {
        guard let height = heighTextField.text, height != "" else {
            self.showCardAlert(title: nil, message: "Boyunuzu giriniz", type: .Error)
            return false
        }
        
        if !(height.count == 2 || height.count == 3) {
            self.showCardAlert(title: nil, message: "Boyunuzu kontrol edin", type: .Warning)
            return false
        }
        
        if !Validator.numberValidate(height) {
            self.showCardAlert(title: nil, message: "Boyunuz sayısal değer olmalı", type: .Error)
            return false
        }
        
        return true
    }
    
    fileprivate func userAgreementValidated() -> Bool {
        if !approved {
            self.showCardAlert(title: nil, message: "Kullanıcı sözleşmesini kabul etmelisiniz", type: .Info)
        }
        
        return approved
    }
    
    fileprivate func genderValidated() -> (selected: Bool, gender: String?) {
        if gender == nil {
            self.showCardAlert(title: nil, message: "Cinsiyet seçiniz", type: .Warning)
            return (false, nil)
        } else {
            return (true, gender)
        }
    }
    
    fileprivate func userBirthdaySelected() -> Bool {
        if birthdayTextField.text?.isEmpty ?? true {
            self.showCardAlert(title: nil, message: "Doğum tarihi giriniz.", type: .Error)
            return false
        } else {
            return true
        }
    }
    
}

// MARK: - Hide Keyboard
extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


// MARK: - DatePicker
extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    func pickUpDate(_ textField : UITextField) {
        // DatePicker
        datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.minimumDate = self.dateFormatter?.date(from: "01/01/1923")!
        textField.inputView = datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.red
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Tamam", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Vazgeç", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        self.birthdayTextField.text = self.dateFormatter?.string(from: datePicker.date)
        birthdayTextField.resignFirstResponder()
    }
    
    @objc func cancelClick() {
        birthdayTextField.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.birthdayTextField {
            self.pickUpDate(self.birthdayTextField)
        }
    }
}
