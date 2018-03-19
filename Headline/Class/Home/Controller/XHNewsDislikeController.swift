//
//  XHNewsDislikeController.swift
//  Headline
//
//  Created by Li on 2018/3/15.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SwiftTheme

class XHNewsDislikeController: XHTriangleViewController {
    
    override var contentSize: CGSize {
        let width = UIScreen.main.bounds.width - 20
        return CGSize(width: width, height: 55 + CGFloat((filterWords.count + 1) / 2) * 35)
    }
    
    private let titleLabel = UILabel()
    
    private let dislikeButton = UIButton(type: .custom)
    
    var news: XHHomeNews!
    
    private var filterWords: [XHFilterWords] {
        return news.filter_words!
    }
    
    weak var delegate: XHNewsDislikeControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.left.equalTo(10)
            $0.top.equalToSuperview()
            $0.height.equalTo(50)
        }
        titleLabel.theme_textColor = ThemeColorPicker.black
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        reloadTitleLabel()
        contentView.addSubview(dislikeButton)
        dislikeButton.snp.makeConstraints{
            $0.right.equalTo(-10)
            $0.width.equalTo(adaptWidth(100))
            $0.centerY.equalTo(titleLabel)
            $0.height.equalTo(30)
        }
        dislikeButton.setTitle("不感兴趣", for: .normal)
        dislikeButton.setTitle("确定", for: .selected)
        dislikeButton.theme_setTitleColor(ThemeColorPicker.white, forState: .normal)
        dislikeButton.theme_backgroundColor = ThemeColorPicker.red
        dislikeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        dislikeButton.layer.cornerRadius = 15
        dislikeButton.layer.masksToBounds = true
        dislikeButton.addTarget(self, action: #selector(dislike), for: .touchUpInside)
        configureFliterWords()
    }
    
    private func configureFliterWords() {
        for index in 0 ..< filterWords.count {
            let word = filterWords[index]
            let button = UIButton(type: .custom)
            button.theme_setTitleColor(ThemeColorPicker.black, forState: .normal)
            button.theme_setTitleColor(ThemeColorPicker.red, forState: .selected)
            button.isSelected = word.is_selected
            button.layer.theme_borderColor = word.is_selected ? ThemeCGColorPicker.red : .gray
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 5
            button.layer.masksToBounds = true
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.setTitle(word.name, for: .normal)
            contentView.addSubview(button)
            button.addTarget(self, action: #selector(selectItem(_:)), for: .touchUpInside)
            button.tag = index
            button.snp.makeConstraints{
                if index % 2 == 0 {
                    $0.left.equalTo(titleLabel)
                } else {
                    $0.right.equalTo(-10)
                }
                $0.height.equalTo(30)
                $0.width.equalTo(contentView.snp.width).multipliedBy(0.5).offset(-12.5)
                $0.top.equalTo(titleLabel.snp.bottom).offset(index/2 * 35)
            }
        }
    }
    
    @objc private func dislike() {
        delegate?.dislikeController(self, didDislike: news)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func selectItem(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let word = filterWords[sender.tag]
        word.is_selected = sender.isSelected
        sender.layer.theme_borderColor = word.is_selected ? ThemeCGColorPicker.red : .gray
        reloadTitleLabel()
    }
    
    private func reloadTitleLabel() {
        let count = filterWords.filter{ $0.is_selected }.count
        if count > 0 {
            let attributedString = NSMutableAttributedString(string: "已选\(count)个理由")
            attributedString.addAttribute(.foregroundColor, value: UIColor(hex: Theme.shared.style == .day ? 0xc44943 : 0x211d21), range: NSRange(location: 2, length: attributedString.length - 5))
            titleLabel.attributedText = attributedString
            dislikeButton.isSelected = true
        } else {
            titleLabel.text = "可选理由，精准屏蔽"
            dislikeButton.isSelected = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

@objc protocol XHNewsDislikeControllerDelegate: NSObjectProtocol {
    
    func dislikeController(_ controller: XHNewsDislikeController,didDislike news: XHHomeNews)
    
}
