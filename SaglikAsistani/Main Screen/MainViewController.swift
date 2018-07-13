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
            self.initiliziationWebView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
}

// MARK: - Auxiliary Methods
extension MainViewController {
    
    fileprivate func initiliziationWebView() {
        
        // Internetin olmamasi durumunda, kullaniciya alert gosterilir ve alert tekrar kendini cagirir.
        if !ConnectionCoordinator.isConnectedToNetwork() {
            let alert = UIAlertController.init(title: "İnternete bağlı değilsiniz", message: "Lütfen bağlantınızı kontrol edin", preferredStyle: .alert)
            let action = UIAlertAction(title: "Tekrar Dene", style: .default) { (_) in
                self.initiliziationWebView()
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        
            return
        }
        
        
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
    
}

//let frame = CGRect.init(x: self.view.center.x - 40, y: self.view.center.y - 40, width: 80, height: 80)
//self.retryButton = UIButton.init(frame: frame)
//
//private var retryButton: UIButton!
//
//fileprivate func createRetryButton() {
//    print("createRetryButton")
//    retryButton.imageView?.image = #imageLiteral(resourceName: "reloadIcon")
//    retryButton.addTarget(nil, action: #selector(retryButtonTouched), for: .touchUpInside)
//    self.webView.addSubview(retryButton)
//}
//
//
//@objc func retryButtonTouched() {
//    self.initiliziationWebView()
//    print("retryButtonTouched")
//}
