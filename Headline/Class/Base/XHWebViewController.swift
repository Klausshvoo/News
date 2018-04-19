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
    
    var webView: WKWebView!
    
    private lazy var userContentController: WKUserContentController = {
        return WKUserContentController()
    }()
    
    private var names: [String]?
    
    convenience init(javaScriptMethods names: [String]?) {
        self.init(nibName: nil, bundle: nil)
        let congiguration = WKWebViewConfiguration()
        if let names = names {
            congiguration.userContentController = userContentController
            for name in names {
                congiguration.userContentController.add(self, name: name)
            }
            self.names = names
        }
        webView = WKWebView(frame: .zero, configuration: congiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
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
