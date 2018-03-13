//
//  XHViewControllerAnimatedTransitioning.swift
//  XHWaterCollectionView
//
//  Created by Li on 2018/3/3.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

enum UIViewControllerTransitioningType {
    case present,dismiss
}

/// 抽象类，必须使用它的子类，并重写animateTransition(using transitionContext:）
class XHViewControllerAnimatedTransitioning: NSObject {

    var type: UIViewControllerTransitioningType
 
    init(transitioningType: UIViewControllerTransitioningType) {
        self.type = transitioningType
    }
    
}

extension XHViewControllerAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
}
