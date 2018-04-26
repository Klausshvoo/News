//
//  XHViewControllerPushTransitioning.swift
//  Headline
//
//  Created by Li on 2018/4/22.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHViewControllerPushTransitioning: XHViewControllerAnimatedTransitioning {

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        switch type {
        case .present:
            let tempView = fromVC.view.snapshotView(afterScreenUpdates: false)!
            containerView.addSubview(tempView)
            tempView.frame = fromVC.view.frame
            fromVC.view.isHidden = true
            containerView.addSubview(toVC.view)
            toVC.view.frame = CGRect(origin: CGPoint(x: UIScreen.main.bounds.width, y: 0), size: UIScreen.main.bounds.size)
            if transitionContext.isAnimated {
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    tempView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    tempView.alpha = 0.8
                    toVC.view.transform = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
                }) { (_) in
                    transitionContext.completeTransition(true)
                }
            } else {
                tempView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                tempView.alpha = 0.8
                toVC.view.frame = UIScreen.main.bounds
                transitionContext.completeTransition(true)
            }
        case .dismiss:
            let index = max(0, containerView.subviews.count - 2)
            let tempView = containerView.subviews[index]
            if transitionContext.isAnimated {
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    tempView.transform = .identity
                    tempView.alpha = 1.0
                    fromVC.view.transform = .identity
                }) { (_) in
                    if transitionContext.transitionWasCancelled {
                        transitionContext.completeTransition(false)
                    } else {
                        tempView.removeFromSuperview()
                        toVC.view.isHidden = false
                        transitionContext.completeTransition(true)
                    }
                }
            } else {
                toVC.view.isHidden = false
                transitionContext.completeTransition(true)
            }
        }
    }
}
