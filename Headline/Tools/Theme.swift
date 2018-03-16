//
//  Theme.swift
//  Headline
//
//  Created by Li on 2018/3/12.
//  Copyright © 2018年 Personal. All rights reserved.
//

import Foundation
import SwiftTheme

enum ThemeStyle: Int {
    case day,night
}



class Theme: NSObject {
    
    static let shared = Theme()
    
    override init() {
        let rawValue = UserDefaults.standard.integer(forKey: "ThemeStyle")
        style = ThemeStyle.init(rawValue: rawValue) ?? .day
        ThemeManager.setTheme(index: style.rawValue)
        super.init()
    }
    
    var style: ThemeStyle {
        didSet {
            if oldValue == style {
                return
            }
            UserDefaults.standard.set(style.rawValue, forKey: "ThemeStyle")
            ThemeManager.setTheme(index: style.rawValue)
        }
    }
    
//    var fontStyle: ThemeFontStyle {
//        didSet {
//            if oldValue == fontStyle {
//                return
//            }
//            ThemeManager.set
//        }
//    }
    
}

extension UILabel {
    
    convenience init(textThemeColor: ThemeColorPicker = .black) {
        self.init()
        theme_textColor = textThemeColor
    }
}

extension ThemeColorPicker {
    
    static let tabBarColor = ThemeColorPicker(colors: "#f6f6f6","#211d21")
    
    static let background = ThemeColorPicker(colors: "#f6f6f6","#2b292b")
    
    static let white = ThemeColorPicker(colors: "#ffffff","#6a6a6a")
    
    static let gray = ThemeColorPicker(colors: "#a5a5a5","#6a6a6a")
    
    static let black = ThemeColorPicker(colors: "#333333","#6a6a6a")
    
    static let red = ThemeColorPicker(colors: "#c44943","#211d21")
}

extension ThemeCGColorPicker {
    
    static let background = ThemeCGColorPicker(colors: "#ffffff","#2a2a2a")
    
    static let red = ThemeCGColorPicker(colors: "#c44943","#211d21")
    
    static let gray = ThemeCGColorPicker(colors: "#a5a5a5","#6a6a6a")
    
}

enum ThemeFontStyle: Int {
    
    case small,mid,big,veryBig
    
}




