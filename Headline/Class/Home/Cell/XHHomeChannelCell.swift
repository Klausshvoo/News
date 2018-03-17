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
        label.font = UIFont.systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.snp.makeConstraints{
            $0.edges.equalTo(UIEdgeInsets.zero)
        }
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
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
        imageView.isHidden = !XHChannelEditManager.shared.isEidting
        NotificationCenter.default.addObserver(self, selector: #selector(itemDidEditable), name: .homeChannelDidEditable, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setChannel(_ channel: XHHomeChannel) {
        super.setChannel(channel)
        if label.text == "推荐" {
            imageView.isHidden = true
        }
        label.theme_textColor = channel.isSelected ? ThemeColorPicker.red : .black
    }
    
    @objc private func itemDidEditable(_ noti: Notification) {
        if let object = noti.object as? Bool,label.text != "推荐" {
            imageView.isHidden = !object
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

class XHHomeChannelAddCell: XHHomeChannelCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.theme_textColor = ThemeColorPicker.black
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
    
    private var titleLabel = UILabel()
    
    private var subTitleLabel = UILabel()
    
    private var editButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(subTitleLabel)
        addSubview(editButton)
        titleLabel.snp.makeConstraints{
            $0.left.equalTo(10)
            $0.centerY.equalToSuperview()
        }
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.theme_textColor = ThemeColorPicker.black
        subTitleLabel.snp.makeConstraints{
            $0.left.equalTo(titleLabel.snp.right).offset(5)
            $0.bottom.equalTo(titleLabel)
        }
        subTitleLabel.font = UIFont.systemFont(ofSize: 12)
        subTitleLabel.theme_textColor = ThemeColorPicker.gray
        editButton.snp.makeConstraints{
            $0.right.equalTo(-10)
            $0.bottom.equalTo(titleLabel)
            $0.height.equalTo(24)
            $0.width.greaterThanOrEqualTo(50)
        }
        editButton.setTitle("编辑", for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        editButton.setTitle("完成", for: .selected)
        editButton.theme_setTitleColor(ThemeColorPicker.red, forState: .normal)
        editButton.layer.cornerRadius = 12
        editButton.layer.masksToBounds = true
        editButton.layer.borderWidth = 1
        editButton.layer.theme_borderColor = ThemeCGColorPicker.red
        editButton.addTarget(self, action: #selector(changeEditState(_:)), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(homeChannelDidEditable(_:)), name: .homeChannelDidEditable, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setEditable(_ isEditable: Bool) {
        if isEditable {
            editButton.isHidden = false
            titleLabel.text = "我的频道"
            subTitleLabel.text = editButton.isSelected ? "拖拽可以排序" : "点击进入频道"
        } else {
            editButton.isHidden = true
            titleLabel.text = "频道推荐"
            subTitleLabel.text = "点击添加频道"
        }
    }
    
    @objc private func changeEditState(_ sender: UIButton) {
        XHChannelEditManager.shared.isEidting = !sender.isSelected
        NotificationCenter.default.post(name: .homeChannelDidEditable, object: !sender.isSelected)
    }
    
    @objc private func homeChannelDidEditable(_ noti: Notification) {
        if let object = noti.object as? Bool,!editButton.isHidden {
            editButton.isSelected = object
            subTitleLabel.text = editButton.isSelected ? "拖拽可以排序" : "点击进入频道"
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

class XHChannelEditManager: NSObject {
    
    static let shared: XHChannelEditManager = XHChannelEditManager()
    
    var isEidting: Bool = false
    
}
