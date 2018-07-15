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

    fileprivate lazy var activityIndicator: UIActivityIndicatorView = {
        let activityInd = UIActivityIndicatorView.init()
        activityInd.color = UIColor.black
        activityInd.hidesWhenStopped = true
        activityInd.center = self.view.center
        self.view.addSubview(activityInd)
        return activityInd
    }()
    
    private lazy var webView: WKWebView = {
        var webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            
            self.webView.navigationDelegate = self
            
            let frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.view.frame.height)
            self.webView.frame = frame
            
//            self.setDefaultViewFrame()
            self.view.addSubview(self.webView)
            
            self.activityIndicator.startAnimating()
            self.startWebView()
        }
    }
}

// MARK: - Auxiliary Methods
extension MainViewController {
    
    fileprivate func initiliazeSignOutButton() {
        let frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        let logoutButton = UIButton.init(frame: frame)
        
        logoutButton.setImage(#imageLiteral(resourceName: "logout-icon"), for: UIControlState.normal)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        logoutButton.addTarget(nil, action: #selector(logoutButtonTouched), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(logoutButton)
        
        // button constraints
        let trailingConstraint = NSLayoutConstraint(item: logoutButton,
                                                    attribute: NSLayoutAttribute.trailing,
                                                    relatedBy: NSLayoutRelation.equal,
                                                    toItem: view,
                                                    attribute: NSLayoutAttribute.trailing,
                                                    multiplier: 1,
                                                    constant: 20)
        
        let topConstraint = NSLayoutConstraint(item: logoutButton,
                                               attribute: NSLayoutAttribute.top,
                                               relatedBy: NSLayoutRelation.equal,
                                               toItem: view,
                                               attribute: NSLayoutAttribute.top,
                                               multiplier: 1,
                                               constant: -17)
        
        let widthConstraint = NSLayoutConstraint(item: logoutButton,
                                                 attribute: NSLayoutAttribute.width,
                                                 relatedBy: NSLayoutRelation.equal,
                                                 toItem: nil,
                                                 attribute: NSLayoutAttribute.notAnAttribute,
                                                 multiplier: 1,
                                                 constant: 100)

        let heightConstraint = NSLayoutConstraint(item: logoutButton,
                                                  attribute: NSLayoutAttribute.height,
                                                  relatedBy: NSLayoutRelation.equal,
                                                  toItem: nil,
                                                  attribute: NSLayoutAttribute.notAnAttribute,
                                                  multiplier: 1,
                                                  constant: 100)
        
        view.addConstraints([trailingConstraint, topConstraint, widthConstraint, heightConstraint])
    }
    
    fileprivate func startWebView() {
        
        if !isInternetAvailable() { return }
        
        let urlString = "http://uygulama.planpiri.com/mobil/go/" + UserValues.loginToken!
        guard let url = URL.init(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }
    
    fileprivate func setConstraintToWebViewInFirstLoaded() {
        let topConstraint = NSLayoutConstraint(item: self.webView,
                                               attribute: NSLayoutAttribute.top,
                                               relatedBy: NSLayoutRelation.equal,
                                               toItem: self.view.safeAreaLayoutGuide.topAnchor,
                                               attribute: NSLayoutAttribute.top,
                                               multiplier: 1,
                                               constant: -7)
        self.view.addConstraint(topConstraint)
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
    
    fileprivate func setDefaultViewFrame() {
        let frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.view.frame.height)
        self.view.frame = frame
    }
    
    @objc fileprivate func logoutButtonTouched() {
        let alert = UIAlertController(title: "Oturumu kapatmak istiyor musunuz?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Oturumu Kapat", style: .default) { (_) in
            
            // kullanici verileri sifirlanip, root view login olarak ayarlanir ve kullanici ana menuye donderilir.
            UserValues.loginToken = nil
            UserValues.userId = nil
            
            let destination = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
            self.present(destination, animated: true, completion: nil)
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
  
}

// MARK: - WKNavigationDelegate
extension MainViewController {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.initiliazeSignOutButton()
        self.activityIndicator.stopAnimating()
    }
}
