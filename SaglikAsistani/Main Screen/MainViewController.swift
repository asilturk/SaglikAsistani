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
        
        DispatchQueue.main.async {
            self.webView = WKWebView()
            self.webView.navigationDelegate = self
            self.view = self.webView
            self.startWebView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - Auxiliary Methods
extension MainViewController {
    
    fileprivate func startWebView() {
        
        if !isInternetAvailable() { return }
      
        guard let loginToken = UserValues.loginToken, loginToken != "" else {
            // TODO: - token yuklenmediyse login ekranina yonlendir.
            return
        }
        
        // TODO: - Token kontrolu yap
        let urlString = "http://uygulama.planpiri.com/mobil/go/" + loginToken
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
    
    fileprivate func loginTokenRegenerated() -> Bool {

        return false
    }
    
}
