//
//  MainViewController.swift
//  SaglikAsistani
//
//  Created by Burak Furkan Asilturk on 12.07.2018.
//  Copyright © 2018 Burak Furkan Asilturk. All rights reserved.
//

import UIKit
import WebKit

class MainViewController: UIViewController, WKNavigationDelegate {

    private var webView: WKWebView!
    
    override func loadView() {
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
        let urlString = "http://uygulama.planpiri.com/mobil/go/" + UserValues.loginToken
        guard let url = URL.init(string: urlString) else { return }
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}

