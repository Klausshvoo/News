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
    
    let contentView: UIView = UIView()
    
    var contentSize: CGSize {
        return .zero
    }
    
    private var _contentSize: CGSize {
        return CGSize(width: contentSize.width, height: contentSize.height + arrowHeight)
    }
    
    fileprivate var contentLayer: CAShapeLayer = CAShapeLayer()
    
    private var anchorRect: CGRect
    
    private var arrowPoint: CGPoint = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        drawContentSize()
    }
    
    init(targetView: UIView) {
        anchorRect = targetView.convert(targetView.bounds, to: targetView.window)
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawContentSize() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let path = UIBezierPath()
        arrowPoint.x = anchorRect.midX
        arrowPoint.y = anchorRect.maxY
        let arrowX = anchorRect.midX - edgeMargin
        var arrowY: CGFloat = 0
        var coefficient: CGFloat = 1
        if anchorRect.maxY + _contentSize.height > screenHeight - 32 {
            arrowY = _contentSize.height
            coefficient = -1
            arrowPoint.y = anchorRect.minY
        }
        path.move(to: CGPoint(x: arrowX, y: arrowY))
        var secondX: CGFloat = arrowX - arrowWidth/2
        if arrowX < cornerRadius + arrowWidth {
            secondX = cornerRadius
        } else if arrowX > screenWidth - (edgeMargin * 2 + cornerRadius + arrowWidth) {
            secondX = screenWidth - (edgeMargin * 2 + cornerRadius + arrowWidth)
        }
        let secondY = coefficient * arrowHeight + arrowY
        path.addLine(to: CGPoint(x: secondX, y: secondY))
        var thirdX = arrowX - _contentSize.width / 2 + cornerRadius
        if thirdX < cornerRadius {
            thirdX = cornerRadius
        }
        if arrowX + _contentSize.width / 2 + edgeMargin * 2 > screenWidth {
            thirdX = screenWidth - edgeMargin * 2 - _contentSize.width + cornerRadius
        }
        if secondX != thirdX {
            path.addLine(to: CGPoint(x: thirdX, y: secondY))
        }
        let isUp = coefficient == 1
        path.addArc(withCenter: CGPoint(x: thirdX, y: secondY + coefficient * cornerRadius), radius: cornerRadius, startAngle: isUp ? .pi/2 * 3 : .pi/2, endAngle: .pi, clockwise: !isUp)
        let fourthY = secondY + coefficient * (_contentSize.height - cornerRadius - arrowHeight)
        path.addLine(to: CGPoint(x: thirdX - cornerRadius, y: fourthY))
        path.addArc(withCenter: CGPoint(x: thirdX,y: fourthY), radius: cornerRadius, startAngle: .pi , endAngle: isUp ? .pi/2 : .pi/2 * 3, clockwise: !isUp)
        let fifthX = thirdX + _contentSize.width - 2 * cornerRadius
        path.addLine(to: CGPoint(x: fifthX, y: fourthY + coefficient * cornerRadius))
        path.addArc(withCenter: CGPoint(x: fifthX,y: fourthY), radius: cornerRadius, startAngle: isUp ? .pi/2 : .pi/2 * 3 , endAngle: 0, clockwise: !isUp)
        path.addLine(to: CGPoint(x: fifthX + cornerRadius, y: secondY + coefficient * cornerRadius))
        path.addArc(withCenter: CGPoint(x: fifthX,y: secondY + coefficient * cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: isUp ? .pi/2 * 3 : .pi/2 , clockwise: !isUp)
        path.addLine(to: CGPoint(x: secondX + arrowWidth, y: secondY))
        path.close()
        let y = isUp ? anchorRect.maxY : anchorRect.minY - _contentSize.height
        contentLayer.frame = CGRect(origin: CGPoint(x: thirdX - cornerRadius + edgeMargin, y: y), size: _contentSize)
        contentLayer.path = path.cgPath
        contentLayer.fillColor = UIColor(hex: Theme.shared.style == .day ? 0xffffff : 0x2a2a2a).cgColor
        view.layer.addSublayer(contentLayer)
        let contentY = contentLayer.frame.minY + (isUp ? arrowHeight : 0)
        let contentX = contentLayer.frame.minX
        let contentWidth = _contentSize.width
        let contentHeight = _contentSize.height - arrowHeight
        contentView.frame = CGRect(x: contentX, y: contentY, width: contentWidth, height: contentHeight)
        view.bringSubview(toFront: contentView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first  {
            let point = touch.location(in: view)
            if !contentLayer.frame.contains(point) {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    open func presentAnimation(_ contentLayer: CALayer,duration: TimeInterval) {
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        let toValue = min(UIScreen.main.bounds.width/contentLayer.bounds.width, 1.2)
        scaleAnimation.toValue = toValue
        scaleAnimation.duration = duration/2
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        scaleAnimation.autoreverses = true
        contentLayer.add(scaleAnimation, forKey: nil)
        contentView.layer.add(scaleAnimation, forKey: nil)
    }
    
    open func dismissAnimation(_ contentLayer: CALayer,duration: TimeInterval) {
        editContentLayer(contentLayer)
        editContentViewLayer()
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 1.0
        scaleAnimation.toValue = 0.01
        scaleAnimation.duration = duration
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        scaleAnimation.isRemovedOnCompletion = false
        scaleAnimation.fillMode = kCAFillModeForwards
        contentLayer.add(scaleAnimation, forKey: nil)
        contentView.layer.add(scaleAnimation, forKey: nil)
    }
    
    private func editContentLayer(_ contentLayer: CALayer) {
        let position = contentLayer.position
        var anchorPoint = contentLayer.anchorPoint
        contentLayer.position = arrowPoint
        anchorPoint.x += (arrowPoint.x - position.x)/_contentSize.width
        anchorPoint.y += (arrowPoint.y - position.y)/_contentSize.height
        contentLayer.anchorPoint = anchorPoint
    }
    
    private func editContentViewLayer() {
        let position = contentView.layer.position
        var anchorPoint = contentView.layer.anchorPoint
        contentView.layer.position = arrowPoint
        anchorPoint.x += (arrowPoint.x - position.x)/contentView.bounds.width
        anchorPoint.y += (arrowPoint.y - position.y)/contentView.bounds.height
        contentView.layer.anchorPoint = anchorPoint
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
        var contentLayer: CAShapeLayer
        switch type {
        case .present:
            let tempView = fromVC.view.snapshotView(afterScreenUpdates: false)!
            tempView.frame = fromVC.view.frame
            fromVC.view.isHidden = true
            containerView.addSubview(tempView)
            containerView.addSubview(toVC.view)
            contentLayer = (toVC as! XHTriangleViewController).contentLayer
            toVC.view.frame = UIScreen.main.bounds
            if transitionContext.isAnimated {
                (toVC as! XHTriangleViewController).presentAnimation(contentLayer, duration: transitionDuration(using: transitionContext))
                tempView.alpha = 0.7
                transitionContext.completeTransition(true)
            } else {
                tempView.alpha = 0.7
                transitionContext.completeTransition(true)
            }
        case .dismiss:
            let index = max(0, containerView.subviews.count - 2)
            let tempView = containerView.subviews[index]
            contentLayer = (fromVC as! XHTriangleViewController).contentLayer
            if transitionContext.isAnimated {
                let duration = transitionDuration(using: transitionContext)
                (fromVC as! XHTriangleViewController).dismissAnimation(contentLayer, duration: duration)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: {
                    if transitionContext.transitionWasCancelled {
                        transitionContext.completeTransition(false)
                    } else {
                        contentLayer.removeFromSuperlayer()
                        tempView.alpha = 1
                        transitionContext.completeTransition(true)
                        toVC.view.isHidden = false
                    }
                })
            } else {
                tempView.alpha = 1
                transitionContext.completeTransition(true)
                toVC.view.isHidden = false
            }
        }
    }
}
