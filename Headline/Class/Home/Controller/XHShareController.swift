//
//  XHShareController.swift
//  Headline
//
//  Created by Li on 2018/3/20.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SwiftTheme

class XHShareController: UIViewController {
    
    fileprivate let barView = UIView()
    
    private var isBarViewLoaded: Bool = false
    
    private var shareItems: [UIButton] = []
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 0.7)
        view.addSubview(barView)
        barView.theme_backgroundColor = ThemeColorPicker.background
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        barView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        barView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        barView.heightAnchor.constraint(equalToConstant: 224).isActive = true
        let button = UIButton(type: .custom)
        barView.addSubview(button)
        button.setTitle("取消", for: .normal)
        button.theme_setTitleColor(ThemeColorPicker.black, forState: .normal)
        button.snp.makeConstraints{
            $0.bottom.equalTo(barView)
            $0.height.equalTo(44)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        button.theme_backgroundColor = ThemeColorPicker.white
        button.addTarget(self, action: #selector(dismissForCancle), for: .touchUpInside)
        configureShareItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !isBarViewLoaded,barView.frame != .zero {
            isBarViewLoaded = true
            barView.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height - barView.frame.minY)
            UIView.animate(withDuration: 0.2, animations: {[weak self] in
                self?.barView.transform = .identity
            })
            animatedItems()
        }
    }
    
    fileprivate func configureShareItems() {
        let scrollView = UIScrollView(frame: .zero)
        barView.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: barView.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: barView.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: barView.topAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: barView.heightAnchor, multiplier: 0.5).isActive = true
        let shareItemTypes: [XHShareType] = [.sina,.weixin]
        for shareType in shareItemTypes {
            let button = UIButton(type: .custom)
            let iconName = shareType.icon
            let image = UIImage(named: Theme.shared.style == .day ? iconName : "\(iconName)_night")
            button.setImage(image, for: .normal)
            scrollView.addSubview(button)
            button.setPositionStyle(.vertical, padding: 6)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.leftAnchor.constraint(equalTo: shareItems.isEmpty ? scrollView.leftAnchor : shareItems.last!.rightAnchor, constant: 20).isActive = true
            button.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40).isActive = true
            button.widthAnchor.constraint(equalToConstant: image!.size.width).isActive = true
            button.heightAnchor.constraint(equalToConstant: image!.size.height + 20).isActive = true
            button.theme_setTitleColor(ThemeColorPicker.black, forState: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            button.setTitle(shareType.name, for: .normal)
            button.tag = shareType.rawValue
            shareItems.append(button)
        }
    }
    
    private func animatedItems() {
        for index in 0 ..< shareItems.count {
            let item = shareItems[index]
            UIView.animate(withDuration: 0.2, delay: TimeInterval(index + 1) * 0.1, options: .curveEaseInOut, animations: {
                item.transform = CGAffineTransform(translationX: 0, y: -20)
            }, completion: nil)
        }
    }
    
    @objc private func dismissForCancle() {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first,touch.view == view {
            dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

enum XHShareType: Int {
    case qq,sina,weixin
    
    var name: String {
        switch self {
        case .qq:
            return "QQ"
        case .sina:
            return "新浪"
        case .weixin:
            return "微信"
        }
    }
    
    var icon: String {
        switch self {
        case .qq:
            return "qqicon_login_profile"
        case .sina:
            return "sinaicon_login_profile"
        case .weixin:
            return "weixinicon_login_profile"
        }
    }
    
}

extension XHShareController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return XHShareControllerTransitioning(transitioningType: .dismiss)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return XHShareControllerTransitioning(transitioningType: .present)
    }
    
}

class XHShareControllerTransitioning: XHViewControllerAnimatedTransitioning {
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        switch type {
        case .present:
            let containerView = transitionContext.containerView
            containerView.addSubview(toVC.view)
            transitionContext.completeTransition(true)
        default:
            if transitionContext.isAnimated {
                let barView = (fromVC as! XHShareController).barView
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    barView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: barView.bounds.width, height: barView.bounds.height)
                }, completion: { (_) in
                    fromVC.view.removeFromSuperview()
                    transitionContext.completeTransition(true)
                })
            } else {
                fromVC.view.removeFromSuperview()
                transitionContext.completeTransition(true)
            }
        }
    }
    
    override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
}
