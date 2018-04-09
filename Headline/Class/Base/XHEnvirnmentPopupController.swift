//
//  XHEnvirnmentPopupController.swift
//  Headline
//
//  Created by Li on 2018/4/8.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

enum XHEnvirnment: Int {
    case release,pre_release,beta
    
    var name: String {
        switch self {
        case .release:
            return "正式版"
        case .pre_release:
            return "预发布"
        case .beta:
            return "测试版"
        }
    }
    
}

fileprivate let runEnvirnment: String = "envirnment"

class XHEnvirnmentPopupController: UIView,UIBarPositioning {
    
    var barPosition: UIBarPosition {
        return .top
    }
    
    fileprivate var envirnment: XHEnvirnment = {
        let rawValue = UserDefaults.standard.integer(forKey: runEnvirnment)
        return XHEnvirnment(rawValue: rawValue)!
    }()
    
    private lazy var longPress: UILongPressGestureRecognizer = {
        let temp = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        temp.minimumPressDuration = 1
        return temp
    }()
    
    private lazy var itemsView: XHEnvirnmentItemsView = XHEnvirnmentItemsView()

    convenience init(date: String) {
        self.init(frame: .zero)
        backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
        let versionLabel = UILabel()
        addSubview(versionLabel)
        versionLabel.textColor = UIColor.white
        versionLabel.font = UIFont.systemFont(ofSize: 13)
        versionLabel.numberOfLines = 3
        var version: String = ""
        var build: String = ""
        if let info = Bundle.main.infoDictionary {
            version = info["CFBundleShortVersionString"] as? String ?? "1.0.0"
            build = info["CFBundleVersion"] as? String ?? "1"
        }
        versionLabel.text = "version：\(version)\nbuild：\(envirnment.name)(\(build))\ndate：\(date)"
        versionLabel.translatesAutoresizingMaskIntoConstraints = false
        versionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
        versionLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        versionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
        addGestureRecognizer(longPress)
        longPress.isEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if layer.mask == nil {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft,.bottomLeft], cornerRadii: CGSize(width: 30, height: 30))
            let cornerLayer = CAShapeLayer()
            cornerLayer.path = path.cgPath
            layer.mask = cornerLayer
        }
    }
    
    @objc private func handleTap() {
        animationHidden(!_animationHidden)
    }
    
    @objc private func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            itemsView.showAnimation(in: window!)
        }
    }
    
    private var _animationHidden: Bool = true
    
    func animationHidden(_ isHidden: Bool) {
        guard _animationHidden != isHidden else { return }
        var rect = frame
        if isHidden {
            rect.origin.x = UIScreen.main.bounds.width - 30
        } else {
            rect.origin.x = UIScreen.main.bounds.width - frame.width
        }
        if !isHidden {
            backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.7)
        }
        UIView.animate(withDuration: 0.25, animations: {[weak self] in
            self?.frame = rect
            if isHidden {
                self?.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
            }
        }) { [weak self](finished) in
            self?._animationHidden = isHidden
            self?.longPress.isEnabled = !isHidden
        }
    }
    
    
}

private class XHEnvirnmentItemsView: UIView {
    
    private let backView: UIView = UIView()
    
    convenience init() {
        self.init(frame: .zero)
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        addSubview(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        var envirnments: [XHEnvirnment] = [.release,.pre_release,.beta]
        let current = UserDefaults.standard.integer(forKey: runEnvirnment)
        envirnments.remove(at: current)
        backView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        backView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        backView.heightAnchor.constraint(equalToConstant: CGFloat(envirnments.count) * 50 - 10).isActive = true
        backView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: UIScreen.main.bounds.height == 812 ? -32 : -10).isActive = true
        for index in 0 ..< envirnments.count {
            let envirnment = envirnments[index]
            let button = UIButton(type: .system)
            button.setTitle(envirnment.name, for: .normal)
            backView.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leftAnchor.constraint(equalTo: backView.leftAnchor).isActive = true
            button.rightAnchor.constraint(equalTo: backView.rightAnchor).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: CGFloat(index) * -50).isActive = true
            button.tag = envirnment.rawValue
            button.addTarget(self, action: #selector(changeEnvirnment(_:)), for: .touchUpInside)
            button.backgroundColor = UIColor.white
        }
    }
    
    @objc private func changeEnvirnment(_ sender: UIButton) {
        UserDefaults.standard.set(sender.tag, forKey: runEnvirnment)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            exit(0)
        }
    }
    
    func showAnimation(in view: UIView) {
        view.addSubview(self)
        frame = UIScreen.main.bounds
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeFromSuperview()
    }
    
}
