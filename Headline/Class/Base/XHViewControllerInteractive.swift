//
//  XHViewControllerInteractive.swift
//  Headline
//
//  Created by Li on 2018/3/16.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

protocol XHViewControllerInteractive: NSObjectProtocol {
    
    var isInteractive: Bool { get set }
    
    var interactiveTransition: UIPercentDrivenInteractiveTransition { get set }
    
}

extension XHViewControllerInteractive where Self: UIViewController {
    
    func handleGestureRecognizer(_ state: UIGestureRecognizerState,percent: CGFloat) {
        switch state {
        case .began:
            isInteractive = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactiveTransition.update(percent)
        case .ended:
            isInteractive = false
            if percent < 0.5 {
                interactiveTransition.cancel()
            } else {
                interactiveTransition.finish()
            }
        default:
            isInteractive = false
            interactiveTransition.cancel()
        }
    }
}


