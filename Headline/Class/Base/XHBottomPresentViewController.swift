//
//  XHBottomPersentViewController.swift
//  Headline
//
//  Created by Li on 2018/3/16.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SwiftTheme

class XHBottomPersentViewController: UIViewController {
    
    var isInteractive: Bool = false
    
    var interactiveTransition: UIPercentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.theme_backgroundColor = ThemeColorPicker.background
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
        addInteractiveGestureRecognizer()
        configureDismissButton()
    }
    
    private func configureDismissButton() {
        let button = UIButton(type: .custom)
        button.theme_setImage(ThemeImagePicker(names: "titlebar_close","titlebar_close_night"), forState: .normal)
        view.addSubview(button)
        button.snp.makeConstraints{
            $0.left.equalTo(15)
            $0.height.equalTo(30)
            $0.width.equalTo(30)
            $0.top.equalTo(15)
        }
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension XHBottomPersentViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return XHViewControllerBottomTransitioning(transitioningType: .dismiss)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let type = XHViewControllerBottomTransitioning(transitioningType: .present)
        type.viewHeight = UIScreen.main.bounds.height - UIApplication.shared.statusBarFrame.height
        return type
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractive ? interactiveTransition : nil
    }
    
}

extension XHBottomPersentViewController: XHViewControllerInteractive {
    
    private func addInteractiveGestureRecognizer() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(pan)
        pan.delegate = self
    }
    
    @objc func handlePan(_ pan: UIPanGestureRecognizer) {
        var percent: CGFloat = 0
        let transition = pan.translation(in: view).y
        percent = transition / view.bounds.height
        handleGestureRecognizer(pan.state, percent: percent)
    }
}

extension XHBottomPersentViewController: UIGestureRecognizerDelegate {}
