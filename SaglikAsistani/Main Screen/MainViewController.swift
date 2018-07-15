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
            self.webView.scrollView.isScrollEnabled = false
            self.view = self.webView
            self.signOutButtonConfiguration()
            self.startWebView()
            
        }
    }
}

// MARK: - Auxiliary Methods
extension MainViewController {
    
    fileprivate func signOutButtonConfiguration() {
        let frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let logoutButton = UIButton.init(frame: frame)
        logoutButton.setImage(#imageLiteral(resourceName: "logout-icon"), for: UIControlState.normal)
        
        self.view.addSubview(logoutButton)
      
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
//        let horizontalConstraint = NSLayoutConstraint(item: logoutButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
//        let verticalConstraint = NSLayoutConstraint(item: logoutButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0)
        let trailingConstraint = NSLayoutConstraint(item: logoutButton, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 16)
        let topConstraint = NSLayoutConstraint(item: logoutButton, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: -10)
        let widthConstraint = NSLayoutConstraint(item: logoutButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
        let heightConstraint = NSLayoutConstraint(item: logoutButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 100)
        view.addConstraints([trailingConstraint, topConstraint, widthConstraint, heightConstraint])

    }
    
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
}
