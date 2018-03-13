//
//  XHTabBarItemController.swift
//  Headline
//
//  Created by Li on 2018/3/12.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

protocol XHTabBarItemController: NSObjectProtocol {
    
    var tabBarItemImageName: String { get }
    
}

extension XHTabBarItemController where Self: UIViewController {
    
    func setTabBarItemImage() {
        let postfix = Theme.shared.style == .day ? "" : "_night"
        tabBarItem.image = UIImage(named: tabBarItemImageName + "_tabbar" + postfix)
        tabBarItem.selectedImage = UIImage(named: tabBarItemImageName + "_tabbar_press" + postfix)
    }
    
}
