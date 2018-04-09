//
//  XHWindow.swift
//  Headline
//
//  Created by Li on 2018/4/9.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHWindow: UIWindow {

    private var envinmentController: XHEnvirnmentPopupController?
    
    private var isEnvinmentable: Bool?
    
    func enableEnvinment(_ dateString: String) {
        guard isEnvinmentable == nil else { return }
        isEnvinmentable = true
        envinmentController = XHEnvirnmentPopupController(date: dateString)
        addSubview(envinmentController!)
        envinmentController?.translatesAutoresizingMaskIntoConstraints = false
        envinmentController?.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        envinmentController?.leftAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        envinmentController?.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let flag = isEnvinmentable,flag {
            envinmentController?.animationHidden(true)
        }
    }

}
