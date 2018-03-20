//
//  XHVideoCoverView.swift
//  Headline
//
//  Created by Li on 2018/3/19.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SwiftTheme

class XHVideoCoverView: UIView {

    private let imageView = UIImageView()
    
    private let playButton = UIButton(type: .custom)
    
    private let durationLabel = UILabel()
    
    private let titleLabel = UILabel()
    
    private let countLabel = UILabel()
    
    convenience init() {
        self.init(frame: .zero)
        addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        addSubview(playButton)
        playButton.setBackgroundImage(UIImage(named: "titlebar_shadow"), for: .normal)
        playButton.setImage(UIImage(named: "video_play"), for: .normal)
        playButton.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        configureTitleLabel()
        configureCountLabel()
        durationLabel.font = UIFont.systemFont(ofSize: 9)
        durationLabel.theme_textColor = ThemeColorPicker.white
        addSubview(durationLabel)
        durationLabel.theme_backgroundColor = ThemeColorPicker.black
        durationLabel.layer.cornerRadius = 12
        durationLabel.layer.masksToBounds = true
        durationLabel.snp.makeConstraints{
            $0.bottom.equalTo(-5)
            $0.right.equalTo(-10)
            $0.width.equalTo(adaptWidth(50))
            $0.height.equalTo(24)
        }
        durationLabel.textAlignment = .center
        durationLabel.alpha = 0.6
    }
    
    private func configureTitleLabel() {
        addSubview(titleLabel)
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
        addSubview(countLabel)
        countLabel.font = UIFont.systemFont(ofSize: 10)
        countLabel.theme_textColor = ThemeColorPicker.white
        countLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.equalTo(15)
        }
    }
    
    var imagePath: String? {
        didSet {
            if let path = imagePath {
                imageView.kf.setImage(with: URL(string: path))
            } else {
                imageView.image = nil
            }
        }
    }
    
    func addTarget(_ target: Any?,action: Selector) {
        playButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    var duration: String? {
        didSet {
            durationLabel.text = duration
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var readCount: Int = 0 {
        didSet {
            countLabel.text = "\(readCount)次播放"
        }
    }
}
