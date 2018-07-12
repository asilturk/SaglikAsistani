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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            self.webView = WKWebView()
            self.webView.navigationDelegate = self
            self.view = self.webView
            
            self.initiliziationWebView()
        }
    }
    
}

extension MainViewController {
    fileprivate func initiliziationWebView() {
        guard let loginToken = UserValues.loginToken, loginToken != "" else { return }
        let urlString = "http://uygulama.planpiri.com/mobil/go/" + loginToken
        guard let url = URL.init(string: urlString) else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}

