//
//  XHTriangleViewController.swift
//  Headline
//
//  Created by Li on 2018/3/15.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SwiftTheme

class XHTriangleViewController: UIViewController {
    
    var contentInsets: UIEdgeInsets = UIEdgeInsets(top: 8, left: 10, bottom: 0, right: 10)
    
    var contentView: UIView = UIView()
    
    var contentSize: CGSize! {
        didSet {
            layoutContentLayerAnchor()
        }
    }
    
    private var anchorRect: CGRect!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        contentView.theme_backgroundColor = ThemeColorPicker.background
        contentView.layer.cornerRadius = 5
        contentView.layer.masksToBounds = true
    }
    
    init(targetView: UIView) {
        super.init(nibName: nil, bundle: nil)
        anchorRect = targetView.convert(targetView.bounds, to: targetView.window)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutContentLayerAnchor() {
        var layerAnchor: CGPoint = .zero
        var layerPosition: CGPoint = .zero
        var x = anchorRect.midX
        var y: CGFloat = 0
        let contentWidth = contentSize.width
        let height = contentSize.height
        if x > UIScreen.main.bounds.midX {
            x = x - 3 *  contentWidth / 4
            layerAnchor.x = 1
            layerPosition.x = x + contentWidth
        } else {
            x = x - contentWidth / 4
            layerPosition.x = x
        }
        if x < contentInsets.left {
            x = contentInsets.left
            layerPosition.x = x
        }
        if x + contentWidth > UIScreen.main.bounds.width - contentInsets.right {
            x = UIScreen.main.bounds.width - contentWidth - contentInsets.right
            layerPosition.x = x + contentWidth
        }
        if anchorRect.midY < UIScreen.main.bounds.midY {
            y = anchorRect.maxY
            layerPosition.y = y
        } else {
            y = anchorRect.minY - contentInsets.top - height
            layerAnchor.y = 1
            layerPosition.y = y + height
        }
        contentView.frame = CGRect(x: x, y: y, width: contentWidth, height: height)
        drawTriangle()
        contentView.layer.position = layerPosition
        contentView.layer.anchorPoint = layerAnchor
    }
    
    private func drawTriangle() {
        var x = anchorRect.midX - contentView.frame.minX
        var y: CGFloat = 0
        var leftPoint: CGPoint
        var rightPoint: CGPoint
        if x < 2 * contentInsets.top {
            x = 2 * contentInsets.top
        }
        if x > contentView.bounds.width - 2 * contentInsets.top {
            x = contentView.bounds.width - 2 * contentInsets.top
        }
        if anchorRect.midY < UIScreen.main.bounds.midY {
            leftPoint = CGPoint(x: x - contentInsets.top, y: contentInsets.top)
            rightPoint = CGPoint(x: x + contentInsets.top, y: contentInsets.top)
        } else {
            y = contentView.bounds.height
            leftPoint = CGPoint(x: x - contentInsets.top, y: y - contentInsets.top)
            rightPoint = CGPoint(x: x + contentInsets.top, y: y - contentInsets.top)
        }
        let arrowLayer = CAShapeLayer()
        arrowLayer.frame = contentView.bounds
        arrowLayer.fillColor = UIColor(hex: 0xffffff).cgColor
        let path = UIBezierPath()
        path.move(to: CGPoint(x: x, y: y))
        path.addLine(to: rightPoint)
        path.addLine(to: leftPoint)
        path.lineJoinStyle = .round
        arrowLayer.path = path.cgPath
        contentView.layer.addSublayer(arrowLayer)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touch = touches.first
        if touch?.view != contentView {
            dismiss(animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension XHTriangleViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return XHTriangleViewControllerTransitioning(transitioningType: .dismiss)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return XHTriangleViewControllerTransitioning(transitioningType: .present)
    }
    
}

class XHTriangleViewControllerTransitioning: XHViewControllerAnimatedTransitioning {
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: .to)!
        let fromVC = transitionContext.viewController(forKey: .from)!
        let containerView = transitionContext.containerView
        var contentView: UIView
        switch type {
        case .present:
            let tempView = fromVC.view.snapshotView(afterScreenUpdates: false)!
            tempView.frame = fromVC.view.frame
            fromVC.view.isHidden = true
            containerView.addSubview(tempView)
            containerView.addSubview(toVC.view)
            contentView = (toVC as! XHTriangleViewController).contentView
            toVC.view.frame = UIScreen.main.bounds
            contentView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            if transitionContext.isAnimated {
                UIView.animate(withDuration: 0.5, animations: {
                    tempView.alpha = 0.8
                    contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                }, completion: { (_) in
                    transitionContext.completeTransition(true)
                })
            } else {
                tempView.alpha = 0.8
                transitionContext.completeTransition(true)
            }
        case .dismiss:
            let index = max(0, containerView.subviews.count - 2)
            let tempView = containerView.subviews[index]
            contentView = (fromVC as! XHTriangleViewController).contentView
            if transitionContext.isAnimated {
                UIView.animate(withDuration: 0.5, animations: {
                    tempView.alpha = 1
                    contentView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                }, completion: { (_) in
                    if transitionContext.transitionWasCancelled {
                        transitionContext.completeTransition(false)
                    } else {
                        transitionContext.completeTransition(true)
                        toVC.view.isHidden = false
                    }
                })
            } else {
                tempView.alpha = 1
                contentView.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                transitionContext.completeTransition(true)
                toVC.view.isHidden = false
            }
        }
    }
}
