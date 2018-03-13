//
//  XHTabBarController.swift
//  Headline
//
//  Created by Li on 2018/3/12.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SwiftTheme

class XHTabBarController: UITabBarController {
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        let bar = UITabBar.appearance()
        bar.isTranslucent = false
        bar.theme_barTintColor = .tabBarColor
        let item = UITabBarItem.appearance()
        item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        let normalAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 10),.foregroundColor: UIColor(red: 0.31, green: 0.31, blue: 0.31, alpha: 1)]
        item.setTitleTextAttributes(normalAttributes, for: .normal)
        let selectAttributes: [NSAttributedStringKey: Any] = [.font: UIFont.systemFont(ofSize: 10),.foregroundColor: UIColor(red: 0.97, green: 0.35, blue: 0.35, alpha: 1)]
        item.setTitleTextAttributes(selectAttributes, for: .selected)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildViewController(XHHomeViewController(), title: "首页")
        addChildViewController(XHMelonVideoViewController(), title: "西瓜视频")
        addChildViewController(XHWeiHeadlineViewController(), title: "微头条")
        addChildViewController(XHSmallVideoViewController(), title: "小视频")
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange(_:)), name: .themeDidChange, object: nil)
    }
    
    private func addChildViewController(_ childController: UIViewController&XHTabBarItemController,title: String) {
        childController.setTabBarItemImage()
        childController.tabBarItem.title = title
        addChildViewController(childController)
    }
    
    @objc private func themeDidChange(_ noti: Notification) {
        let style = noti.object as! ThemeStyle
        Theme.shared.style = style
        for childViewController in childViewControllers {
            let child = childViewController as! UIViewController&XHTabBarItemController
            child.setTabBarItemImage()
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension Notification.Name {
    
    static let themeDidChange: Notification.Name = Notification.Name("themeDidChange")
    
}

