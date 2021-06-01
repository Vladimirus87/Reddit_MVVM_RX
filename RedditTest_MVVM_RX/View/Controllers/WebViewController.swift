//
//  WebViewController.swift
//  RedditTest_MVVM_RX
//
//  Created by Vladimirus on 28.10.2020.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
        
    @IBOutlet weak var webViewBackground: UIView!
    
    private var webView: WKWebView!
    
    var urlString: String?
    
    override func loadView() {
        super.loadView()
        webView = WKWebView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        uiSettings()
        
        guard let _urlString = urlString, let url = URL(string: _urlString) else {
            MessageView.sharedInstance.showOnView(message: "Incorrect Url", theme: .error)
            return
        }
        startAnimating()
        webView.load(URLRequest(url: url))
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.bounces = false
    }
    
    private func uiSettings() {
        title = "Web content"
        webView.backgroundColor = .black
        webViewBackground.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: webViewBackground.topAnchor, constant: 0).isActive = true
        webView.bottomAnchor.constraint(equalTo: webViewBackground.bottomAnchor, constant: 0).isActive = true
        webView.trailingAnchor.constraint(equalTo: webViewBackground.trailingAnchor, constant: 0).isActive = true
        webView.leadingAnchor.constraint(equalTo: webViewBackground.leadingAnchor, constant: 0).isActive = true
    }

}



extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.stopAnimating()
    }
}

