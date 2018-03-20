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
    
    private let coverView = XHVideoCoverView()
    
    private let avatarView = UIImageView()
    
    private let nameLabel = UILabel()
    
    private let useInfoButton = UIButton(type: .custom)
    
    private let concernButton = UIButton(type: .custom)
    
    private let shareView = XHHomeVideoShareView()
    
    private let commentButton = UIButton(type: .custom)
    
    private let moreButton = UIButton(type: .custom)
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCoverView()
        configureMoreButton()
        configureCommentButton()
        configureConcernButton()
        configureUserAvatarView()
        configureShareView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        shouldBeginPlaying()
    }
    
    private func configureMoreButton() {
        contentView.addSubview(moreButton)
        moreButton.theme_setImage(ThemeImagePicker(names: "more","more_night"), forState: .normal)
        moreButton.addTarget(self, action: #selector(presentShareController), for: .touchUpInside)
        moreButton.snp.makeConstraints{
            $0.right.equalToSuperview()
            $0.top.equalTo(coverView.snp.bottom)
            $0.height.equalTo(44)
            $0.width.greaterThanOrEqualTo(40)
        }
    }
    
    @objc private func presentShareController() {
        let shareController = XHShareController()
        controller?.present(shareController, animated: true, completion: nil)
    }
    
    private func configureCommentButton() {
        contentView.addSubview(commentButton)
        commentButton.theme_setImage(ThemeImagePicker(names: "comment","comment_night"), forState: .normal)
        commentButton.setTitle("0", for: .normal)
        commentButton.theme_setTitleColor(ThemeColorPicker.black, forState: .normal)
        commentButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        commentButton.snp.makeConstraints{
            $0.width.greaterThanOrEqualTo(50)
            $0.height.equalTo(44)
            $0.top.equalTo(moreButton)
            $0.right.equalTo(moreButton.snp.left).offset(-5)
        }
    }
    
    private func configureConcernButton() {
        contentView.addSubview(concernButton)
        concernButton.theme_setImage(ThemeImagePicker(names: "video_add","video_add_night"), forState: .normal)
        concernButton.setTitle("关注", for: .normal)
        concernButton.setTitle("已关注", for: .selected)
        concernButton.theme_setTitleColor(ThemeColorPicker.black, forState: .normal)
        concernButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        concernButton.snp.makeConstraints{
            $0.width.greaterThanOrEqualTo(50)
            $0.height.equalTo(44)
            $0.top.equalTo(moreButton)
            $0.right.equalTo(commentButton.snp.left).offset(-5)
        }
    }
    
    private func configureUserAvatarView() {
        contentView.addSubview(useInfoButton)
        contentView.addSubview(avatarView)
        contentView.addSubview(nameLabel)
        nameLabel.theme_textColor = ThemeColorPicker.black
        nameLabel.font = UIFont.systemFont(ofSize: 13)
        nameLabel.snp.makeConstraints{
            $0.left.equalTo(15)
            $0.top.equalTo(moreButton)
            $0.bottom.equalTo(moreButton)
        }
        avatarView.layer.cornerRadius = 20
        avatarView.layer.masksToBounds = true
        avatarView.snp.makeConstraints{
            $0.width.equalTo(40)
            $0.height.equalTo(40)
            $0.bottom.equalTo(nameLabel.snp.top).offset(7)
            $0.left.equalTo(nameLabel)
        }
        useInfoButton.snp.makeConstraints{
            $0.top.equalTo(avatarView)
            $0.bottom.equalTo(nameLabel)
            $0.left.equalTo(nameLabel)
            $0.right.equalTo(nameLabel.snp.right)
        }
    }
    
    private func configureShareView() {
        contentView.addSubview(shareView)
        shareView.snp.makeConstraints{
            $0.left.equalToSuperview()
            $0.top.equalTo(nameLabel)
            $0.height.equalTo(44)
        }
        shareView.animation(for: false)
    }
    
    private var _news: XHHomeNews?
    
    override func setNews(_ news: XHHomeNews) {
        coverView.title = news.title
        coverView.readCount = news.read_count
        coverView.duration = news.videoDuration
        coverView.imagePath = news.video_detail_info?.detail_video_large_image.path
        commentButton.setTitle(news.commentCountDescription, for: .normal)
        if let avatarUrl = news.user_info?.avatar_url {
            avatarView.kf.setImage(with: URL(string: avatarUrl))
        }
        nameLabel.text = news.user_info?.name
        concernButton.isSelected = news.user_info?.follow ?? false
        setAutoHeight(bottomView: moreButton, bottomMargin: 0)
    }
    
    func shouldBeginPlaying() {
        shareView.animation(for: true)
        avatarView.isHidden = true
        nameLabel.isHidden = true
        useInfoButton.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        shareView.animation(for: false)
        avatarView.isHidden = false
        nameLabel.isHidden = false
        useInfoButton.isHidden = false
    }
}

