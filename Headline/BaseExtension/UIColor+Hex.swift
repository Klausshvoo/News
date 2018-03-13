//
//  UIColor+Hex.swift
//  News
//
//  Created by Li on 2018/2/25.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: UInt32,alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xff00) >> 8) / 255.0
        let blue = CGFloat(hex & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static var kRed = UIColor(red: 196.0/255.0, green: 73.0/255.0, blue: 67.0/255.0, alpha: 1.0)
    
}
