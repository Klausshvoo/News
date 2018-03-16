//
//  XHViewControllerBottomTransitioning.swift
//  Headline
//
//  Created by Li on 2018/3/16.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHViewControllerBottomTransitioning: XHViewControllerAnimatedTransitioning {
    
    var viewHeight: CGFloat = UIScreen.main.bounds.height

    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        switch type {
        case .present:
            let tempView = fromVC.view.snapshotView(afterScreenUpdates: false)!
            tempView.frame = fromVC.view.frame
            fromVC.view.isHidden = true
            containerView.addSubview(tempView)
            containerView.addSubview(toVC.view)
            toVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: viewHeight)
            if transitionContext.isAnimated {
                UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                    toVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - toVC.view.frame.height, width: UIScreen.main.bounds.width, height: toVC.view.frame.height)
                    tempView.alpha = 0.7
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
                })
            } else {
                toVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - toVC.view.frame.height, width: UIScreen.main.bounds.width, height: toVC.view.frame.height)
                transitionContext.completeTransition(true)
                tempView.alpha = 0.7
            }
        case .dismiss:
            let index = max(0, containerView.subviews.count - 2)
            let tempView = containerView.subviews[index]
            if transitionContext.isAnimated {
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    fromVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: fromVC.view.frame.height)
                    tempView.alpha = 1
                }, completion: { (_) in
                    if !transitionContext.transitionWasCancelled {
                        transitionContext.completeTransition(true)
                        toVC.view.isHidden = false
                        tempView.removeFromSuperview()
                    } else {
                        transitionContext.completeTransition(false)
                    }
                })
            } else {
                fromVC.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: fromVC.view.frame.height)
                tempView.alpha = 1
                toVC.view.isHidden = false
                tempView.removeFromSuperview()
            }
        }
        
    }
}
