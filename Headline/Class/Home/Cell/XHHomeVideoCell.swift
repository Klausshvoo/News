//
//  XHHomeVideoCell.swift
//  Headline
//
//  Created by Li on 2018/3/19.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SwiftTheme

class XHHomeVideoCell: XHHomeNewsCell {

    private let titleLabel = UILabel()
    
    private let countLabel = UILabel()
    
    private let coverView = XHVideoCoverView()
    
    private let avatarView = UIImageView()
    
    private let nameLabel = UILabel()
    
    private let concernButton = UIButton(type: .custom)
    
    private let shareView = UIView()
    
    private let commentButton = UIButton(type: .custom)
    
    private let moreButton = UIButton(type: .custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCoverView()
        configureTitleLabel()
        configureCountLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.theme_textColor = ThemeColorPicker.white
        titleLabel.snp.makeConstraints{
            $0.left.equalTo(15)
            $0.top.equalTo(10)
            $0.right.equalTo(-15)
        }
    }
    
    private func configureCountLabel() {
        contentView.addSubview(countLabel)
        countLabel.font = UIFont.systemFont(ofSize: 10)
        countLabel.theme_textColor = ThemeColorPicker.white
        countLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.equalTo(15)
        }
    }
    
    private func configureCoverView() {
        contentView.addSubview(coverView)
        coverView.addTarget(self, action: #selector(shouldPlayVideo))
        coverView.snp.makeConstraints{
            $0.left.equalToSuperview()
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
        }
        let height = NSLayoutConstraint(item: coverView, attribute: .height, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 9/16, constant: 0)
        height.isActive = true;
    }
    
    @objc private func shouldPlayVideo() {
        
    }
    
    private var _news: XHHomeNews?
    
    override func setNews(_ news: XHHomeNews) {
        titleLabel.text = news.title
        countLabel.text = "5次播放"
        coverView.backgroundColor = UIColor.red
        coverView.duration = news.videoDuration
        setAutoHeight(bottomView: coverView, bottomMargin: 44)
    }
    
}

