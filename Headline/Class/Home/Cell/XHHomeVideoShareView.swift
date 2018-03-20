//
//  XHHomeVideoShareView.swift
//  Headline
//
//  Created by Li on 2018/3/20.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SwiftTheme

class XHHomeVideoShareView: UIView {
    
    private var buttons: [UIButton] = []
    
    private var label = UILabel()
    
    convenience init() {
        self.init(frame: .zero)
        addSubview(label)
        label.font = UIFont.systemFont(ofSize: 10)
        label.theme_textColor = ThemeColorPicker.black
        label.text = "分享到"
        label.snp.makeConstraints{
            $0.left.equalTo(15)
            $0.centerY.equalToSuperview()
        }
        let imageNames = ["video_center_share_pyq","video_center_share_weChat"]
        var lastView: UIView = label
        for index in 0 ..< imageNames.count {
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: imageNames[index]), for: .normal)
            button.addTarget(self, action: #selector(share(_:)), for: .touchUpInside)
            addSubview(button)
            button.tag = index
            button.snp.makeConstraints{
                $0.left.equalTo(lastView.snp.right).offset(5)
                $0.centerY.equalToSuperview()
                $0.top.equalToSuperview()
                if index == imageNames.count - 1 {
                    $0.right.equalToSuperview()
                }
            }
            buttons.append(button)
            lastView = button
        }
        
    }
    
    @objc private func share(_ sender: UIButton) {
        
    }
    
    func animation(for show: Bool) {
        isHidden = !show
        if show {
            for button in buttons {
                button.frame = CGRect(origin: CGPoint(x: label.frame.maxX - button.frame.width, y: button.frame.minY), size: button.bounds.size)
            }
            UIView.animate(withDuration: 0.25, animations: {[weak self] in
                var x = self!.label.frame.maxX + 5
                for button in self!.buttons {
                    button.frame = CGRect(origin: CGPoint(x: x, y: button.frame.minY), size: button.bounds.size)
                    x += button.frame.width + 5
                }
            })
        }
    }
}
