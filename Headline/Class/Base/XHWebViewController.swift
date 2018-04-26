//
//  XHWebViewController.swift
//  Headline
//
//  Created by Li on 2018/4/19.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import WebKit

class XHWebViewController: UIViewController {
    
    let webView: WKWebView
    
    var showProgress: Bool = false {
        didSet {
            guard oldValue != showProgress else { return }
            if showProgress {
                webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
                if progressView == nil {
                    progressView = UIProgressView()
                    progressView?.progressTintColor = UIColor.green
                    progressView?.trackTintColor = UIColor.white
                    progressView?.translatesAutoresizingMaskIntoConstraints = false
                }
                view.addSubview(progressView!)
                progressView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                progressView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                progressView?.topAnchor.constraint(equalTo: webView.topAnchor).isActive = true
                progressView?.heightAnchor.constraint(equalToConstant: 2).isActive = true
            } else {
                webView.removeObserver(self, forKeyPath: "estimatedProgress")
                progressView?.removeFromSuperview()
            }
        }
    }
    
    private lazy var userContentController: WKUserContentController = {
        return WKUserContentController()
    }()
    
    private(set) var progressView: UIProgressView?
    
    private var names: [String]?
    
    init(javaScriptMethods names: [String]?) {
        let congiguration = WKWebViewConfiguration()
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        congiguration.preferences = preferences
        webView = WKWebView(frame: .zero, configuration: congiguration)
        super.init(nibName: nil, bundle: nil)
        if let names = names {
            congiguration.userContentController = userContentController
            for name in names {
                congiguration.userContentController.add(self, name: name)
            }
            self.names = names
        }
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        view.backgroundColor = UIColor.white
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        progressView?.progress = Float(webView.estimatedProgress)
        progressView?.isHidden = webView.estimatedProgress == 1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        if let names = self.names {
            for name in names {
                userContentController.removeScriptMessageHandler(forName: name)
            }
        }
    }

}

extension XHWebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: nil, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = defaultText
        }
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler(alert.textFields?.first?.text)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: { (_) in
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (_) in
            completionHandler(false)
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

extension XHWebViewController: WKNavigationDelegate {}

extension XHWebViewController: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }
    
}

extension URLRequest {
    
    var cookie: String? {
        let cookieStorage = HTTPCookieStorage.shared
        if let cookies = cookieStorage.cookies {
            let temp = cookies.map{"\($0.name) = \($0.value)"}.joined(separator: ";")
            return temp
        }
        return nil
    }
}
