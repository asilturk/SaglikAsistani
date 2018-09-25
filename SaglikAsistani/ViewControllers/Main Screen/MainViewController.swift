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
        webView.frame = self.view.frame
        webView.scrollView.isScrollEnabled = false
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    private func didLoadProcess() {
        
        // notification'a tiklandiginda yakalam icin delegate atanmasi
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.pushNotificationDelegate = self
        
        // web view olusturmasi ve atamasi
        DispatchQueue.main.async {
            let frame = CGRect(x: 0, y: 10, width: self.view.frame.width, height: self.view.frame.height)
            self.webView.frame = frame
            self.webView.navigationDelegate = self
            
            self.view.addSubview(self.webView)
            
            self.activityIndicator.startAnimating()
            self.startWebView()
        }
    }
    
    /// Webview'in url ve login token'a gore baslatilmasi.
    fileprivate func startWebView() {
        
        if !internetAvailableForLoadWebview() { return }
        
        let urlString = "http://uygulama.planpiri.com/mobil/go/" + UserValues.loginToken!
        guard let url = URL.init(string: urlString) else { return }
        self.webView.load(URLRequest(url: url))
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
    
    /// kullanici paylasima tiklandiginda alinan verileri parse etmede kullanilir
    fileprivate func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
  
    /// Sosyal mecraalarda paylasim
    fileprivate func share(title: String?, text: String?) {
        let activityController = UIActivityViewController.init(activityItems: [title, text], applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
    }
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
//        print("Oyanada buyanada salla")
        webView.evaluateJavaScript("shake_ios_gorev_tamamla()") { (result, error) in
            if error != nil {
                print(result)
            }
        }
    }
}

// MARK: - WKNavigationDelegate
extension MainViewController {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        self.initiliazeSignOutButton()
        self.activityIndicator.stopAnimating()
    }
}


// MARK: - WebView Delegates
extension MainViewController {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        var action: WKNavigationActionPolicy?
        defer { decisionHandler(action ?? .allow) }
        
        guard let url = navigationAction.request.url else { return }
        
        print("tiklanan url:", url)

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
            
            if targetURLString.hasPrefix("http//") {
                targetURLString = String(url.absoluteString.dropFirst(15))
                targetURLString = "https://" + targetURLString
            }
            
            if url.absoluteString.hasPrefix("htpps//") {
                targetURLString = String(url.absoluteString.dropFirst(16))
                targetURLString = "https://" + targetURLString
            }
            
            let targetURL = URL.init(string: targetURLString)

            UIApplication.shared.open(targetURL!, options: [:], completionHandler: nil)
        }
        
        // share butonu ile verilerin paylasilmasi
        if navigationAction.navigationType == .linkActivated, url.absoluteString.contains("shareme://") {
            let urlString = String(url.absoluteString.dropFirst(10))

            guard let decodeString = urlString.decodeUrl() else {
                return
            }
            
            guard let dict = convertToDictionary(text: decodeString) else {
                return
            }
            
            let title = dict["title"] as? String
            let text = dict["text"] as? String
            
            self.share(title: title, text: text)

        }
        
    }
}


extension MainViewController: PushNotificaitonDelegate {
    func notificationTapped(_ targetURL: URL) {
        print("AMAN ALLAHIM :D")
    }
}
