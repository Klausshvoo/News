//
//  UIView+ViewController.swift
//  Headline
//
//  Created by Li on 2018/3/17.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

extension UIView {
    
    var controller: UIViewController? {
        var responder: UIResponder? = next
        while responder != nil {
            if let responder = responder as? UIViewController {
                return responder
            }
            responder = responder?.next
        }
        return nil
    }
    
}
