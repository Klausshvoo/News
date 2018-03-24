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
    
    fileprivate let barView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 244, width: UIScreen.main.bounds.width, height: 244))
    
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
//        let button = UIButton(type: .custom)
//        barView.addSubview(button)
//        button.setTitle("取消", for: .normal)
//        button.theme_setTitleColor(ThemeColorPicker.black, forState: .normal)
//        button.snp.makeConstraints{
//            $0.bottom.equalTo(barView)
//            $0.height.equalTo(44)
//            $0.left.equalToSuperview()
//            $0.right.equalToSuperview()
//        }
//        button.theme_backgroundColor = ThemeColorPicker.white
        let layout = XHPickerViewLayout()
        layout.indicatorStyle = .highlight
        let picker = XHPickerView(frame: barView.bounds, layout: layout)
        barView.addSubview(picker)
        picker.dataSource = self
        picker.register(XHPickerViewCell.self, forCellReuseIdentifier: "cell")
        picker.reloadData()
        picker.delegate = self
    }
    
    fileprivate func animatedItems() {
//        let shareItemNames = ["qqicon_login_profile","sinaicon_login_profile","weixinicon_login_profile"]
//        for itemName in shareItemNames {
//            let button = UIButton(type: .custom)
//            button.theme_setImage(ThemeImagePicker(names: itemName,"\(itemName)_night"), forState: .normal)
//            barView.addSubview(button)
//
//        }
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

extension XHShareController: XHPickerViewDataSource {
    
    func picker(_ picker: XHPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 12
    }
    
    func picker(_ picker: XHPickerView, cellForRowAt indexPath: IndexPath) -> XHPickerViewCell {
        let cell = picker.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.label.text = "\(indexPath.row)"
        return cell
    }
    
    
    func numberOfComponents(_ picker: XHPickerView) -> Int {
        return 2
    }
    
}

extension XHShareController: XHPickerViewDelegate {
    
    func picker(_ picker: XHPickerView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
//    func picker(_ picker: XHPickerView, willSelectRowAt indexPath: IndexPath) {
//        let cell = picker.cellForRow(at: indexPath)
//        cell.contentView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//    }
//
//    func picker(_ picker: XHPickerView, willDeselectRowAt indexPath: IndexPath) {
//        let cell = picker.cellForRow(at: indexPath)
//        cell.contentView.transform = CGAffineTransform.identity
//    }
    
    func picker(_ picker: XHPickerView, didScrollIn component: Int) {
        let cells = picker.cellsIntersectWithIndicatorView(inComponent: component)
        for (cell,rect) in cells {
            cell.label.selectedRect = rect
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
            if transitionContext.isAnimated {
                let barView = (toVC as! XHShareController).barView
                barView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: barView.bounds.width, height: barView.bounds.height)
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    barView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - barView.bounds.height, width: barView.bounds.width, height: barView.bounds.height)
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
                    (toVC as! XHShareController).animatedItems()
                })
            } else {
                transitionContext.completeTransition(true)
            }
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
