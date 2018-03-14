//
//  XHHomeViewController.swift
//  Headline
//
//  Created by Li on 2018/3/12.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SwiftTheme

class XHHomeViewController: XHViewController,XHTabBarItemController {
    
    var tabBarItemImageName: String {
        return "home"
    }
    
    private let pageTitleView = XHPageTitleView()
    
    private let pageContentView = XHPageCollectionView()
    
    private var homeChannels: [XHHomeChannel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePageTitleView()
        configruePageCollectionView()
        XHHomeChannel.queryChannels { [weak self](channels) in
            if let channels = channels {
                self?.homeChannels = channels
                self?.pageTitleView.reloadData()
                self?.pageContentView.reloadData()
            }
        }
    }
    
    private func configurePageTitleView() {
        pageTitleView.dataSource = self
        pageTitleView.delegate = self
        view.addSubview(pageTitleView)
        pageTitleView.snp.makeConstraints{
            $0.left.equalTo(view)
            $0.right.equalTo(view)
            $0.height.equalTo(36)
            $0.top.equalTo(view).offset(64)
        }
        let tailView = UIButton(type: .custom)
        tailView.theme_setImage(ThemeImagePicker(names: "home_add_channel","home_add_channel_night"), forState: .normal)
        tailView.theme_setImage(ThemeImagePicker(names: "home_add_channel","home_add_channel_night"), forState: .highlighted)
        tailView.theme_setBackgroundImage(ThemeImagePicker(names: "shadow_add_titlebar","shadow_add_titlebar_night"), forState: .normal)
        tailView.theme_setBackgroundImage(ThemeImagePicker(names: "shadow_add_titlebar","shadow_add_titlebar_night"), forState: .highlighted)
        tailView.sizeToFit()
        pageTitleView.tailView = tailView
    }
    
    private func configruePageCollectionView() {
        view.addSubview(pageContentView)
        pageContentView.delegate = pageTitleView
        pageContentView.dataSource = self
        pageContentView.snp.makeConstraints{
            $0.left.equalTo(pageTitleView)
            $0.right.equalTo(pageTitleView)
            $0.top.equalTo(pageTitleView.snp.bottom)
            $0.bottom.equalTo(view)
        }
        view.bringSubview(toFront: pageTitleView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        for viewController in childViewControllers {
            if let controller = viewController as? XHPageController,controller.isInReuse {
                viewController.removeFromParentViewController()
            }
        }
    }

}

extension XHHomeViewController: XHPageTitleViewDataSource {
    
    func numberOfItems(_ pageTitleView: XHPageTitleView) -> Int {
        return homeChannels.count
    }
    
    func pageTitleView(_ pageTitleView: XHPageTitleView, titleForItemAt index: Int) -> String {
        return homeChannels[index].name
    }
    
}

extension XHHomeViewController: XHPageTitleViewDelegate {
    
    func pageTitleView(_ pageTitleView: XHPageTitleView, didSelectItemAt index: Int) {
        pageContentView.contentOffset = CGPoint(x: pageContentView.bounds.width * CGFloat(index), y: 0)
    }
}

extension XHHomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeChannels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! XHPageCollectionViewCell
        let channel = homeChannels[indexPath.row]
        let viewControllers = (childViewControllers as! [XHHomeChannelController]).filter{ $0.category == channel.category }
        if let viewController = viewControllers.first {
            cell.setController(viewController, inControl: true)
        } else {
            let viewController = XHHomeChannelController()
            viewController.category = channel.category
            cell.setController(viewController, inControl: false)
            addChildViewController(viewController)
        }
        return cell
    }
}

