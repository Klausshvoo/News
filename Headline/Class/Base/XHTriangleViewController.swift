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
    
    var cornerRadius: CGFloat = 5
    
    var edgeMargin: CGFloat = 10
    
    var arrowHeight: CGFloat = 8
    
    var arrowWidth: CGFloat = 8
    
    private var contentSize: CGSize! {
        didSet {
            drawContentSize()
        }
    }
    
    fileprivate var contentLayer: CAShapeLayer!
    
    private var anchorRect: CGRect!
    
    private var contentRect: CGRect!

    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    public func setContentSize(_ size: CGSize) -> CGRect {
        contentSize = size
        return contentRect
    }
    
    private func drawContentSize() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let path = UIBezierPath()
        let arrowX = anchorRect.midX
        var arrowY = anchorRect.maxY
        var coefficient: CGFloat = 1
        if anchorRect.maxY + contentSize.height > screenHeight - 32 {
            arrowY = anchorRect.minY
            coefficient = -1
        }
        path.move(to: CGPoint(x: arrowX, y: arrowY))
        var secondX: CGFloat = arrowX - arrowWidth/2
        if arrowX < edgeMargin + cornerRadius + arrowWidth {
            secondX = edgeMargin + cornerRadius
        } else if arrowX > screenWidth - (edgeMargin + cornerRadius + arrowWidth) {
            secondX = screenWidth - (edgeMargin + cornerRadius + arrowWidth)
        }
        let secondY = coefficient * arrowHeight + arrowY
        path.addLine(to: CGPoint(x: secondX, y: secondY))
        var thirdX = arrowX - contentSize.width / 2 + cornerRadius
        if thirdX < edgeMargin + cornerRadius {
            thirdX = edgeMargin + cornerRadius
        }
        if arrowX + contentSize.width / 2 + edgeMargin > screenWidth {
            thirdX = screenWidth - edgeMargin - contentSize.width + cornerRadius
        }
        if secondX != thirdX {
            path.addLine(to: CGPoint(x: thirdX, y: secondY))
        }
        let isUp = coefficient == 1
        path.addArc(withCenter: CGPoint(x: thirdX, y: secondY + coefficient * cornerRadius), radius: cornerRadius, startAngle: isUp ? .pi/2 * 3 : .pi/2, endAngle: .pi, clockwise: !isUp)
        let fourthY = secondY + coefficient * (contentSize.height - cornerRadius - arrowHeight)
        path.addLine(to: CGPoint(x: thirdX - cornerRadius, y: fourthY))
        path.addArc(withCenter: CGPoint(x: thirdX,y: fourthY), radius: cornerRadius, startAngle: .pi , endAngle: isUp ? .pi/2 : .pi/2 * 3, clockwise: !isUp)
        let fifthX = thirdX + contentSize.width - 2 * cornerRadius
        path.addLine(to: CGPoint(x: fifthX, y: fourthY + coefficient * cornerRadius))
        path.addArc(withCenter: CGPoint(x: fifthX,y: fourthY), radius: cornerRadius, startAngle: isUp ? .pi/2 : .pi/2 * 3 , endAngle: 0, clockwise: !isUp)
        path.addLine(to: CGPoint(x: fifthX + cornerRadius, y: secondY + coefficient * cornerRadius))
        path.addArc(withCenter: CGPoint(x: fifthX,y: secondY + coefficient * cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: isUp ? .pi/2 * 3 : .pi/2 , clockwise: !isUp)
        path.addLine(to: CGPoint(x: secondX + arrowWidth, y: secondY))
        path.close()
        contentLayer = CAShapeLayer()
        contentLayer.path = path.cgPath
        contentLayer.fillColor = UIColor.red.cgColor
        view.layer.addSublayer(contentLayer)
        print(contentLayer.frame)
        let y = isUp ? arrowY : arrowY - contentSize.height
        contentRect = CGRect(origin: CGPoint.init(x: thirdX - cornerRadius, y: y), size: contentSize)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first  {
            let point = touch.location(in: view)
            if !contentRect.contains(point) {
                dismiss(animated: true, completion: nil)
            }
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
        var contentView: CAShapeLayer
        switch type {
        case .present:
            let tempView = fromVC.view.snapshotView(afterScreenUpdates: false)!
            tempView.frame = fromVC.view.frame
            fromVC.view.isHidden = true
            containerView.addSubview(tempView)
            containerView.addSubview(toVC.view)
            contentView = (toVC as! XHTriangleViewController).contentLayer
            toVC.view.frame = UIScreen.main.bounds
//            contentView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            if transitionContext.isAnimated {
                UIView.animate(withDuration: 0.5, animations: {
                    tempView.alpha = 0.8
//                    contentView.transform = CGAffineTransform(scaleX: 1, y: 1)
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
            contentView = (fromVC as! XHTriangleViewController).contentLayer
            if transitionContext.isAnimated {
                UIView.animate(withDuration: 0.5, animations: {
                    tempView.alpha = 1
//                    contentView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
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
//                contentView.transform = CGAffineTransform(scaleX: 1, y: 0.01)
                transitionContext.completeTransition(true)
                toVC.view.isHidden = false
            }
        }
    }
}
