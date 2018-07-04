//
//  SignUp.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 5.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var userAgreementButton: UIButton!
    
    // kullanici sozlesmesine izin verilip verilmedigini kontrol eder
    lazy var approved: Bool = {
       return false
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
}

// MARK: - Auxiliary Methods
extension SignUpViewController {
    fileprivate func showNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
}
