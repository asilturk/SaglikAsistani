//
//  MainViewController.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 12.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import UIKit
import WebKit

// TODO: - LoginToken bos ise birseyler yapmak gerekebilir. 

class MainViewController: UIViewController, WKNavigationDelegate {

    private var webView: WKWebView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.loginTokenRegenerated() {
            self.startWebView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.webView = WKWebView()
            self.webView.navigationDelegate = self
            self.view = self.webView
            self.startWebView()
        }
        
    }

}

// MARK: - Auxiliary Methods
extension MainViewController {
    
    fileprivate func startWebView() {
        
        if !isInternetAvailable() { return }
        
        let urlString = "http://uygulama.planpiri.com/mobil/go/" + UserValues.loginToken!
        guard let url = URL.init(string: urlString) else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    fileprivate func isInternetAvailable() -> Bool {
        
        // Internetin olmamasi durumunda, kullaniciya alert gosterilir.
        if !InternetConnection.isConnected() {
            let alert = UIAlertController.init(title: "İnternete bağlı değilsiniz", message: "Lütfen bağlantınızı kontrol edin", preferredStyle: .alert)
            let action = UIAlertAction(title: "Tekrar Dene", style: .default) { (_) in
                // Tekrar dene butonuna tikladiginda webview'i tekrar yuklemeye calisir.
                self.startWebView()
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            
            return false
        }
        return true
    }
    
    
    /// Login token araciligiyla session'in kontrol edilmesi, alinan token mevcuttan farkliysa token yenilenip webView yeniden olusturulur.
    ///
    /// - Returns: token yenilendiginde true deger donerek webView'in yenilenmesinde kullanilir.
    fileprivate func loginTokenRegenerated() -> Bool {
        
        Server.controlUserSession(userId: UserValues.userId!,
                                  loginToken: UserValues.loginToken!)
        { (result, message) in
            
            if !result { print("ERROR in loginTokenRegenerated() : \(message)"); return }
            
            

        }
        return false
    }
    
}
