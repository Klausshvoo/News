//
//  XHHomeNewsCell.swift
//  Headline
//
//  Created by Li on 2018/3/14.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SnapKit
import SwiftTheme
import Kingfisher

class XHHomeNewsCell: UITableViewCell,XHTableViewCellAutoHeight {
    
    weak var delegate: XHHomeNewsCellDelegate?
    
    func setNews(_ news: XHHomeNews) {}
    
}

protocol XHHomeNewsCellDelegate: NSObjectProtocol {}

class XHHomeNewsNormalCell: XHHomeNewsCell {
    
    private weak var _delegate: XHNewsDislikeControllerDelegate? {
        if let temp = self.delegate as? NSObject,temp.conforms(to: XHNewsDislikeControllerDelegate.self) {
            return temp as? XHNewsDislikeControllerDelegate
        }
        return nil
    }

    /// 标题
    private let titleLabel = UILabel()
    
    private var titleLabelRight: NSLayoutConstraint?
    
    /// 标签
    private let hotLabel = XHLabel(contentInsets: UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5 ))
    
    /// 媒体
    private let sourceLabel = UILabel()
    
    private var sourceLabelLeft: NSLayoutConstraint?
    
    private var sourceLabelTop: NSLayoutConstraint?
    
    /// 评论数
    private let commentLabel = UILabel()
    
    /// 发表时间
    private let publishTimeLabel = UILabel()
    
    /// 右侧图
    private let rightImageView = UIImageView()
    
    /// 大图
    private let largeImageView = UIImageView()
    
    /// 底部一图
    private let firstImageView = UIImageView()
    
    /// 底部二图
    private let secondImageView = UIImageView()
    
    /// 底部三图
    private let thirdImageView = UIImageView()
    
    /// 不喜欢按钮
    private let dislikeButton = UIButton(type: .custom)
    
    private var dislikeButtonRight: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureTitleLabel()
        configureSourceLabel()
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        configureCommentLabel()
        configurePublishTimeLabel()
        configureHotLabel()
        configureRightImageView()
        configureLargeImageView()
        configureFirstImageView()
        configureSecondImageView()
        configureThirdImageView()
        contentView.theme_backgroundColor = ThemeColorPicker.background
        configureDislikeButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.theme_textColor = ThemeColorPicker.black
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints{
            $0.left.equalTo(contentView).offset(12)
            $0.top.equalTo(contentView).offset(12)
        }
    }
    
    private func layoutTitleLabelRight(_ rightView: UIView,attribute:NSLayoutAttribute) {
        if rightView == titleLabelRight?.secondItem as? UIView {
            return
        }
        titleLabelRight?.isActive = false
        titleLabelRight = NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .lessThanOrEqual, toItem: rightView, attribute: attribute, multiplier: 1.0, constant: -12)
        titleLabelRight?.isActive = true
    }
    
    private func configureSourceLabel() {
        contentView.addSubview(sourceLabel)
        sourceLabel.font = UIFont.systemFont(ofSize: 12)
        sourceLabel.theme_textColor = ThemeColorPicker.black
    }
    
    private func layoutSourceLabelLeft(_ leftView: UIView,attribute:NSLayoutAttribute,constant: CGFloat) {
        if leftView == sourceLabelLeft?.secondItem as? UIView {
            return
        }
        sourceLabelLeft?.isActive = false
        sourceLabelLeft = NSLayoutConstraint(item: sourceLabel, attribute: .left, relatedBy: .equal, toItem: leftView, attribute: attribute, multiplier: 1.0, constant: constant)
        sourceLabelLeft?.isActive = true
    }
    
    private func layoutSourceLabelTop(_ topView: UIView) {
        if topView == sourceLabelTop?.secondItem as? UIView {
            return
        }
        sourceLabelTop?.isActive = false
        sourceLabelTop = NSLayoutConstraint(item: sourceLabel, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .bottom, multiplier: 1.0, constant: 5)
        sourceLabelTop?.isActive = true
    }
    
    private func configureCommentLabel() {
        contentView.addSubview(commentLabel)
        commentLabel.font = UIFont.systemFont(ofSize: 12)
        commentLabel.theme_textColor = ThemeColorPicker.black
        commentLabel.snp.makeConstraints{
            $0.left.equalTo(sourceLabel.snp.right).offset(5)
            $0.centerY.equalTo(sourceLabel)
        }
    }
    
    private func configurePublishTimeLabel() {
        contentView.addSubview(publishTimeLabel)
        publishTimeLabel.font = UIFont.systemFont(ofSize: 12)
        publishTimeLabel.theme_textColor = ThemeColorPicker.black
        publishTimeLabel.snp.makeConstraints{
            $0.left.equalTo(commentLabel.snp.right).offset(5)
            $0.centerY.equalTo(sourceLabel)
        }
    }
    
    private func configureHotLabel() {
        contentView.addSubview(hotLabel)
        hotLabel.snp.makeConstraints{
            $0.left.equalTo(titleLabel)
            $0.centerY.equalTo(sourceLabel)
        }
        hotLabel.isHidden = true
    }
    
    private func configureRightImageView() {
        contentView.addSubview(rightImageView)
        rightImageView.snp.makeConstraints{
            $0.right.equalTo(contentView).offset(-12)
            $0.top.equalTo(titleLabel)
            $0.height.equalTo(rightImageView.snp.width).multipliedBy(0.75)
        }
        let width = NSLayoutConstraint(item: rightImageView, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1/3, constant: -10)
        width.isActive = true
        rightImageView.isHidden = true
    }
    
    private func configureLargeImageView() {
        contentView.addSubview(largeImageView)
        largeImageView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.equalTo(titleLabel)
            $0.right.equalTo(contentView).offset(-12)
            $0.height.equalTo(largeImageView.snp.width).multipliedBy(0.5)
        }
        largeImageView.isHidden = true
    }
    
    private func configureFirstImageView() {
        contentView.addSubview(firstImageView)
        firstImageView.snp.makeConstraints{
            $0.left.equalTo(titleLabel)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.width.equalTo(rightImageView)
            $0.height.equalTo(rightImageView)
        }
        firstImageView.isHidden = true
    }
    
    private func configureSecondImageView() {
        contentView.addSubview(secondImageView)
        secondImageView.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.centerX.equalTo(contentView)
            $0.width.equalTo(firstImageView)
            $0.height.equalTo(firstImageView)
        }
        secondImageView.isHidden = true
    }
    
    private func configureThirdImageView() {
        contentView.addSubview(thirdImageView)
        thirdImageView.snp.makeConstraints{
            $0.top.equalTo(secondImageView)
            $0.right.equalTo(contentView).offset(-12)
            $0.width.equalTo(secondImageView)
            $0.height.equalTo(secondImageView)
        }
        thirdImageView.isHidden = true
    }
    
    private func configureDislikeButton() {
        contentView.addSubview(dislikeButton)
        dislikeButton.theme_setImage(ThemeImagePicker.init(names: "add_textpage","add_textpage_night"), forState: .normal)
        dislikeButton.snp.makeConstraints{
            $0.centerY.equalTo(sourceLabel)
        }
        dislikeButton.addTarget(self, action: #selector(didClickDislike), for: .touchUpInside)
    }
    
    @objc private func didClickDislike(_ sender: UIButton) {
        if _news?.filter_words != nil {
            let dislikeController = XHNewsDislikeController(targetView: sender)
            dislikeController.news = _news
            dislikeController.delegate = _delegate
            controller?.present(dislikeController, animated: true, completion: nil)
        }
    }
    
    private func layoutDislikeButtonRight(_ rightView: UIView,attribute: NSLayoutAttribute) {
        if rightView == dislikeButtonRight?.secondItem as? UIView {
            return
        }
        dislikeButtonRight?.isActive = false
        dislikeButtonRight = NSLayoutConstraint(item: dislikeButton, attribute: .right, relatedBy: .equal, toItem: rightView, attribute: attribute, multiplier: 1.0, constant: -12)
        dislikeButtonRight?.isActive = true
    }
    
    private var _news: XHHomeNews?
    
    override func setNews(_ news: XHHomeNews) {
        _news = news
        titleLabel.text = news.title
        configureHotLabel(news.stick_label)
        sourceLabel.text = news.source
        commentLabel.text = news.commentCountDescription
        publishTimeLabel.text = news.publishTime
        dislikeButton.isHidden = news.filter_words == nil
        if news.has_video {
            if news.video_style == 0 {//图在右侧
                configureMainImageView(0)
                if let videoImage = news.video_detail_info?.detail_video_large_image {
                    rightImageView.kf.setImage(with: URL(string: videoImage.path))
                } else if let image = news.middle_image {
                    rightImageView.kf.setImage(with: URL(string: image.path))
                }
            } else {//显示大图
                configureMainImageView(1)
                largeImageView.kf.setImage(with: URL(string: news.large_image_list!.first!.path))
            }
        } else {
            if let largeImage = news.large_image_list?.first { //显示大图
                configureMainImageView(1)
                rightImageView.kf.setImage(with: URL(string: largeImage.path))
            } else if let imageList = news.image_list,imageList.count > 2 { //显示三图
                configureMainImageView(2)
                firstImageView.kf.setImage(with: URL(string: imageList[0].path))
                secondImageView.kf.setImage(with: URL(string: imageList[1].path))
                thirdImageView.kf.setImage(with: URL(string: imageList[2].path))
            } else if let image = news.middle_image {//右侧图
                configureMainImageView(0)
                rightImageView.kf.setImage(with: URL(string: image.path))
            } else {
                configureMainImageView(3)
            }
        }
    }
    
    private func configureHotLabel(_ text: String?) {
        if let label = text {
            hotLabel.isHidden = false
            layoutSourceLabelLeft(hotLabel, attribute: .right, constant: 5)
            hotLabel.text = label
        } else {
            layoutSourceLabelLeft(titleLabel, attribute: .left, constant: 0)
        }
    }
    
    private func configureMainImageView(_ type: Int) {
        switch type {
        case 0://右侧图
            layoutTitleLabelRight(rightImageView, attribute: .left)
            layoutSourceLabelTop(titleLabel)
            rightImageView.isHidden = false
            layoutDislikeButtonRight(rightImageView, attribute: .left)
            setAutoHeight(bottomViews: [sourceLabel,rightImageView], bottomMargin: 12)
        case 1://大图
            layoutTitleLabelRight(contentView, attribute: .right)
            layoutSourceLabelTop(largeImageView)
            largeImageView.isHidden = false
            layoutDislikeButtonRight(contentView, attribute: .right)
            setAutoHeight(bottomView: sourceLabel, bottomMargin: 12)
        case 2://三图
            layoutTitleLabelRight(contentView, attribute: .right)
            layoutSourceLabelTop(firstImageView)
            firstImageView.isHidden = false
            secondImageView.isHidden = false
            thirdImageView.isHidden = false
            layoutDislikeButtonRight(contentView, attribute: .right)
            setAutoHeight(bottomView: sourceLabel, bottomMargin: 12)
        default://无图
            layoutTitleLabelRight(contentView, attribute: .right)
            layoutSourceLabelTop(titleLabel)
            layoutDislikeButtonRight(contentView, attribute: .right)
            setAutoHeight(bottomView: sourceLabel, bottomMargin: 12)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        largeImageView.isHidden = true
        rightImageView.isHidden = true
        hotLabel.isHidden = true
        firstImageView.isHidden = true
        secondImageView.isHidden = true
        thirdImageView.isHidden = true
    }
    
}

class XHLabel: UIView {
    
    var font: UIFont = UIFont.systemFont(ofSize: 10)
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    private var label = UILabel()
    
    init(contentInsets: UIEdgeInsets) {
        super.init(frame: .zero)
        addSubview(label)
        label.theme_textColor = ThemeColorPicker.red
        label.font = font
        label.snp.makeConstraints{
            $0.edges.equalTo(contentInsets)
        }
        layer.cornerRadius = 5
        layer.masksToBounds = true
        layer.theme_borderColor = ThemeCGColorPicker(arrayLiteral: "#c44943","#211d21")
        layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
