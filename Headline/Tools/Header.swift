//
//  Header.swift
//  Headline
//
//  Created by Li on 2018/3/16.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

func adaptWidth<T: XHRectAdaptable>(_ number: T) -> CGFloat {
    let scale = UIScreen.main.bounds.width/375
    var original: CGFloat = 0
    if number is Int {
        original = CGFloat(number as! Int)
    } else if number is Float {
        original = CGFloat(number as! Float)
    } else if number is Double {
        original = CGFloat(number as! Float)
    } else {
        original = number as! CGFloat
    }
    return scale * original
}



protocol XHRectAdaptable {}

extension Int: XHRectAdaptable{}

extension Float: XHRectAdaptable{}

extension CGFloat: XHRectAdaptable{}

extension Double: XHRectAdaptable{}

