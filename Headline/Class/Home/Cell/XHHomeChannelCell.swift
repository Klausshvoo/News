//
//  XHHomeChannelCell.swift
//  Headline
//
//  Created by Klaus on 2018/3/16.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SwiftTheme

class XHHomeChannelCell: UICollectionViewCell {
    
    fileprivate var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.adjustsFontSizeToFitWidth = true
        label.snp.makeConstraints{
            $0.edges.equalTo(UIEdgeInsets.zero)
        }
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        label.theme_textColor = ThemeColorPicker.black
        label.textAlignment = .center
    }
    
    func setChannel(_ channel: XHHomeChannel) {
        label.text = channel.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Notification.Name {
    
    static let homeChannelDidEditable = Notification.Name("homeChannelDidEditable")
    
}

class XHHomeChannelNormalCell: XHHomeChannelCell {
    
    private var imageView = UIImageView(image: UIImage(named: "closeicon_repost"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.theme_backgroundColor = ThemeColorPicker.gray
        contentView.addSubview(imageView)
        imageView.sizeToFit()
        imageView.center = CGPoint(x: bounds.width, y: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidEditable), name: .homeChannelDidEditable, object: nil)
    }
    
    override func setChannel(_ channel: XHHomeChannel) {
        super.setChannel(channel)
    }
    
    @objc private func itemDidEditable() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class XHHomeChannelAddCell: XHHomeChannelCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.theme_backgroundColor = ThemeColorPicker.white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 1, height: 1)
    }
    
    override func setChannel(_ channel: XHHomeChannel) {
        label.text = "+" + channel.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class XHHomeChannelHeaderView: UICollectionReusableView {
    
    
}
