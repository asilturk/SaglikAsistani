//
//  SignUp.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 5.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import UIKit

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
        if !self.nameFormatValidated() { return }
        if !self.emailFormatValidated() { return }
        if !self.genderValidated().selected { return }
        if !self.weightFormatValidated() { return }
        if !self.heightFormatValidated() { return }
        if !self.userAgreementValidated() { return }
        
        self.showCardViewAlert(title: "Kayıt işlemi başarılı", message: "", type: .Success)
    }
    
    @IBAction func genderTouched(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 { self.gender = "Erkek"} else { self.gender = "Kadın"}
    }
}

// MARK: - Validations
extension SignUpViewController {
    
    fileprivate func nameFormatValidated() -> Bool {
        guard let fullName = nameTextField.text, fullName != "" else {
            self.showCardViewAlert(title: nil, message: "İsim soyisim giriniz", type: .Warning)
            return false
        }
        
        let result = Validator.nameValidate(text: fullName)
        
        if !result {
            self.showCardViewAlert(title: nil, message: "İsminizi kontrol ediniz", type: .Warning)
            return false
        }
        
        return true
    }
    
    fileprivate func emailFormatValidated() -> Bool {
        guard let email = emailTextField.text, email != "" else {
            self.showCardViewAlert(title: nil, message: "Email alanı boş bırakılamaz.", type: .Error)
            return false
        }
        
        let result = Validator.emailValidate(email)
        
        if result.errorMessage != nil {
            self.showCardViewAlert(title: nil, message: result.errorMessage!, type: .Error)
            return false
        }
        
        return true
    }
    
    
    // telefon girilmesi zorunlu olmadigindan burayi eklemedim
    fileprivate func phoneFormatValidated() -> Bool {
        
        guard let phoneNumber = phoneTextField.text, phoneNumber != "" else {
            self.showCardViewAlert(title: nil, message: "Telefon numarası boş bırakılamaz", type: .Error)
            return false
        }
        
        return true
    }
    
    fileprivate func weightFormatValidated() -> Bool {
        guard let weight = weightTextField.text, weight != "" else {
            self.showCardViewAlert(title: nil, message: "Kilonuzu giriniz", type: .Error)
            return false
        }
        
        if !Validator.numberValidate(weight) {
            self.showCardViewAlert(title: nil, message: "Kilonuz sayısal değer olmalı", type: .Error)
            return false
        }
        
        return true
    }
    
    fileprivate func heightFormatValidated() -> Bool {
        guard let height = heighTextField.text, height != "" else {
            self.showCardViewAlert(title: nil, message: "Boyunuzu giriniz", type: .Error)
            return false
        }
        
        if !Validator.numberValidate(height) {
            self.showCardViewAlert(title: nil, message: "Boyunuz sayısal değer olmalı", type: .Error)
            return false
        }
        
        return true
    }
    
    fileprivate func userAgreementValidated() -> Bool {
        if !approved {
            self.showCardViewAlert(title: nil, message: "Kullanici sözleşmesini kabul etmelisiniz", type: .Info)
        }
        
        return approved
    }
    
    fileprivate func genderValidated() -> (selected: Bool, gender: String?) {
        if gender == nil {
            self.showCardViewAlert(title: nil, message: "Cinsiyet seçiniz", type: .Warning)
            return (false, nil)
        } else {
            return (true, gender)
        }
    }
    
    
}

// MARK: - Auxiliary Methods
extension SignUpViewController {
    
    fileprivate func showNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
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
