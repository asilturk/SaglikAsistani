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
            let frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.view.frame.height)
            self.webView.frame = frame
            self.webView.navigationDelegate = self

            self.view.addSubview(self.webView)
            
            self.activityIndicator.startAnimating()
            self.startWebView()
        }
    }
    
    
    /// Kullanicinin her uygulamayi acmasinda server ile iletisime gecerek login token'i kontrol eder.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !InternetConnection.isConnected() { return }
        
        Server.controlUserSession() { (result, message) in
            
            if !result {
                let alert = UIAlertController(title: "Tekrar Login Olmalı", message: message, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Tamam", style: .default, handler: { (_) in
                    self.resetUserValuesAndShowLoginView()
                })
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Auxiliary Methods
extension MainViewController {
    
    
    /// WebView uzerinde programmatic olarak signOut butonu olusturur.
//    fileprivate func initiliazeSignOutButton() {
//        let frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
//        let logoutButton = UIButton.init(frame: frame)
//
//        logoutButton.setImage(#imageLiteral(resourceName: "logout-icon"), for: UIControlState.normal)
//        logoutButton.translatesAutoresizingMaskIntoConstraints = false
//        logoutButton.addTarget(nil, action: #selector(logoutButtonTouched), for: UIControlEvents.touchUpInside)
//
//        self.view.addSubview(logoutButton)
//
//        // button constraints
//        let trailingConstraint = NSLayoutConstraint(item: logoutButton,
//                                                    attribute: NSLayoutAttribute.trailing,
//                                                    relatedBy: NSLayoutRelation.equal,
//                                                    toItem: view,
//                                                    attribute: NSLayoutAttribute.trailing,
//                                                    multiplier: 1,
//                                                    constant: 20)
//
//        let topConstraint = NSLayoutConstraint(item: logoutButton,
//                                               attribute: NSLayoutAttribute.top,
//                                               relatedBy: NSLayoutRelation.equal,
//                                               toItem: view,
//                                               attribute: NSLayoutAttribute.top,
//                                               multiplier: 1,
//                                               constant: -17)
//
//        let widthConstraint = NSLayoutConstraint(item: logoutButton,
//                                                 attribute: NSLayoutAttribute.width,
//                                                 relatedBy: NSLayoutRelation.equal,
//                                                 toItem: nil,
//                                                 attribute: NSLayoutAttribute.notAnAttribute,
//                                                 multiplier: 1,
//                                                 constant: 100)
//
//        let heightConstraint = NSLayoutConstraint(item: logoutButton,
//                                                  attribute: NSLayoutAttribute.height,
//                                                  relatedBy: NSLayoutRelation.equal,
//                                                  toItem: nil,
//                                                  attribute: NSLayoutAttribute.notAnAttribute,
//                                                  multiplier: 1,
//                                                  constant: 100)
//
//        view.addConstraints([trailingConstraint, topConstraint, widthConstraint, heightConstraint])
//    }
    
    
    /// Webview'in url ve login token'a gore baslatilmasi.
    fileprivate func startWebView() {
        
        if !internetAvailableForLoadWebview() { return }
        
        let urlString = "http://uygulama.planpiri.com/mobil/go/" + UserValues.loginToken!
        guard let url = URL.init(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }
    
    // Internetin olmamasi durumunda, kullaniciya tekrar baglanmasi icin alert gosterir.
    fileprivate func internetAvailableForLoadWebview() -> Bool {
    
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
    
    
    /// Logout butonuna tiklanmasi sonrasi tetiklenerek kullaniciya alert gosterilir
    @objc fileprivate func logoutButtonTouched() {
        let alert = UIAlertController(title: "Oturumu kapatmak istiyor musunuz?", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Vazgeç", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Oturumu Kapat", style: .default) { (_) in
            self.resetUserValuesAndShowLoginView()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    

    /// Kullanici verilerinin sifirlanip login ekranina yonlendirir.
    fileprivate func resetUserValuesAndShowLoginView() {
        UserValues.loginToken = nil
        UserValues.userId = nil
        
        let destination = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginNavigationController") as! UINavigationController
        self.present(destination, animated: true, completion: nil)
    }
  
}

// MARK: - WKNavigationDelegate
extension MainViewController {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        self.initiliazeSignOutButton()
        self.activityIndicator.stopAnimating()
    }
}


// MARK: -
extension MainViewController {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        var action: WKNavigationActionPolicy?
        defer { decisionHandler(action ?? .allow) }
        
        guard let url = navigationAction.request.url else { return }
        
        print("tiklanan url:", url)
        
        // TODO: shareme://%7B%22title%22:%22bkgg%22,%20%22text%22:%22bkgg%22%7D bunu parse edip verileri paylas
        
        // TODO: logout sorulacak.
        
//        http://uygulama.planpiri.com/mobil/logout
//        tiklanan url: http://uygulama.planpiri.com/quit:
        
//        if navigationAction.navigationType == .linkActivated, url.absoluteString.hasPrefix("http://www.example.com/open-in-safari") {
//            action = .cancel                  // Stop in WebView
//            UIApplication.shared.openURL(url) // Open in Safari
//        }
        
        // quit tiklandiginda, alert basilip webView yenilenir.
        if navigationAction.navigationType == .linkActivated, url.absoluteString.contains("quit:") {
            self.logoutButtonTouched()
            self.startWebView()
        }
        
        // reklama tikladiginda safariye yonlendirir.
        if navigationAction.navigationType == .linkActivated, url.absoluteString.contains("golink://") {
            
            var targetURLString = String(url.absoluteString.dropFirst(9))
            
            if url.absoluteString.hasPrefix("http//") {
                targetURLString = String(url.absoluteString.dropFirst(15))
                targetURLString = "https://" + targetURLString
            }
            
//            print("url : \(url.absoluteString)")
            targetURLString = "https://" + String(url.absoluteString.dropFirst(15))
            let targetURL = URL.init(string: targetURLString)
//            print("target URL : \(targetURLString)")

            UIApplication.shared.open(targetURL!, options: [:], completionHandler: nil)
        }
        
        
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        print(String(describing: webView.url))
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        let nserror = error as NSError
        if nserror.code != NSURLErrorCancelled {
            webView.loadHTMLString("404 - Page Not Found", baseURL: URL(string: "http://www.planpiri.com/"))
        }
    }
    
}
