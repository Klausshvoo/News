//
//  XHPageCollectionView.swift
//  Headline
//
//  Created by Li on 2018/3/13.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SwiftTheme

class XHPageCollectionView: UICollectionView {
    
    private var flowLayout: UICollectionViewFlowLayout!
    
    convenience init() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        self.init(frame: .zero, collectionViewLayout: flowLayout)
        self.flowLayout = flowLayout
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        bounces = false
        theme_backgroundColor = ThemeColorPicker.background
        register(XHPageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    override func layoutSubviews() {
        var insets = contentInset.bottom + contentInset.top
        if #available(iOS 11.0, *) {
            insets += safeAreaInsets.bottom + safeAreaInsets.top
        }
        if flowLayout.itemSize.height != bounds.height - insets {
            flowLayout.itemSize = CGSize(width: bounds.width, height: bounds.height - insets)
        }
        super.layoutSubviews()
    }
    
}

class XHPageCollectionViewCell: UICollectionViewCell {
    
    lazy var viewController: UIViewController? = {
        var responder = self.next
        while responder != nil {
            if let temp = responder as? UIViewController {
                return temp
            }
            responder = responder?.next
        }
        return nil
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        theme_backgroundColor = ThemeColorPicker.background
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var controller: UIViewController?
    
    func setController(_ controller: UIViewController&XHPageController, inControl: Bool) {
        self.controller = controller
        if !inControl {
            viewController?.addChildViewController(controller)
            controller.view.frame = bounds
        }
        controller.isInReuse = false
        contentView.addSubview(controller.view)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        controller?.view.removeFromSuperview()
        (controller as? XHPageController)?.isInReuse = true
    }
}

protocol XHPageController: NSObjectProtocol {
    
    var isInReuse: Bool { get set }
    
}
