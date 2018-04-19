//
//  XHHomeNewsViewController.swift
//  Headline
//
//  Created by Li on 2018/4/19.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHHomeNewsViewController: XHWebViewController {

    var url: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        webView.backgroundColor = UIColor.white
        let request = URLRequest(url: url)
        request.addValue(<#T##value: String##String#>, forHTTPHeaderField: <#T##String#>)
        webView.load(URLRequest(url: url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
