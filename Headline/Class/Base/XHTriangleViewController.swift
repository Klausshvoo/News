//
//  XHTriangleViewController.swift
//  Headline
//
//  Created by Li on 2018/3/15.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SwiftTheme

enum XHTriangleDirection {
    case up,down
}

class XHTriangleViewController: UIViewController {
    
    var cornerRadius: CGFloat = 5
    
    var edgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    var arrowSize: CGSize = CGSize(width: 8, height: 8)
    
    var priorityDirection: XHTriangleDirection = .up
    
    private(set) var currentDirection: XHTriangleDirection = .up
    
    var tintColor: UIColor = .white {
        didSet {
            contentView.backgroundColor = tintColor
        }
    }
    
    let contentView: UIView = UIView()
    
    private var contentSize: CGSize
    
    private var anchorRect: CGRect

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(contentView)
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        contentView.backgroundColor = tintColor
        drawContentSize()
    }
    
    init(targetView: UIView,contentSize: CGSize) {
        anchorRect = targetView.convert(targetView.bounds, to: targetView.window)
        self.contentSize = contentSize
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
        // 设定箭头的点，以便下面修改contentView的锚点
        var arrowPoint = CGPoint.zero
        let path = UIBezierPath()
        arrowPoint.x = anchorRect.midX
        arrowPoint.y = anchorRect.maxY
        // 设定路径的箭头顶点的X
        var arrowX = contentSize.width/2
        if arrowPoint.x < contentSize.width/2 + edgeInsets.left {
            arrowX = arrowPoint.x - edgeInsets.left
        } else if arrowPoint.x > screenWidth - (contentSize.width/2 + edgeInsets.right) {
            arrowX = contentSize.width - (screenWidth - arrowPoint.x - edgeInsets.right)
        }
        // 设定路径的箭头顶点Y和方向
        var arrowY: CGFloat = 0
        switch priorityDirection {
        case .up:
            var bottomMargin = edgeInsets.bottom
            if UIDevice.current.model == "iPhone",screenHeight == 812,bottomMargin < 32 {
                bottomMargin = 32;
            }
            if arrowPoint.y + contentSize.height + arrowSize.height > screenHeight - bottomMargin {
                arrowY = contentSize.height + arrowSize.height
                arrowPoint.y = anchorRect.minY
                currentDirection = .down
            }
        case .down:
            var topMargin = edgeInsets.top
            if UIDevice.current.model == "iPhone",screenHeight == 812,topMargin < 20 {
                topMargin = 20;
            }
            if anchorRect.minY - contentSize.height - arrowSize.height > topMargin {
                arrowY = contentSize.height + arrowSize.height
                arrowPoint.y = anchorRect.minY
                currentDirection = .down
            }
        }
        // 根据方向设定y的系数
        let coefficient: CGFloat = currentDirection == .down ? -1 : 1
        // 移动路径到箭头的顶点
        path.move(to: CGPoint(x: arrowX, y: arrowY))
        // 计算第二个坐标点，左侧箭头位置
        var secondX: CGFloat = arrowX - arrowSize.width/2
        if secondX < cornerRadius {
            secondX = cornerRadius
        }
        let secondY = coefficient * arrowSize.height + arrowY
        path.addLine(to: CGPoint(x: secondX, y: secondY))
        // 计算第三点，左侧拐角，有可能第三点和第二点会重合
        let thirdX = cornerRadius
        if thirdX != secondX {
            path.addLine(to: CGPoint(x: thirdX, y: secondY))
        }
        // 标记方向
        let isUp: Bool = currentDirection == .up
        // 画左侧第一段圆弧
        path.addArc(withCenter: CGPoint(x: thirdX, y: secondY + coefficient * cornerRadius), radius: cornerRadius, startAngle: isUp ? .pi/2 * 3 : .pi/2, endAngle: .pi, clockwise: !isUp)
        // 过渡到左侧竖线末端
        let fourthY = secondY + coefficient * (contentSize.height - cornerRadius)
        path.addLine(to: CGPoint(x: thirdX - cornerRadius, y: fourthY))
        // 添加左侧末端圆弧
        path.addArc(withCenter: CGPoint(x: thirdX,y: fourthY), radius: cornerRadius, startAngle: .pi , endAngle: isUp ? .pi/2 : .pi/2 * 3, clockwise: !isUp)
        // 添加箭头对面横线
        let fifthX = contentSize.width - cornerRadius
        path.addLine(to: CGPoint(x: fifthX, y: fourthY + coefficient * cornerRadius))
        // 添加右侧末端圆弧
        path.addArc(withCenter: CGPoint(x: fifthX,y: fourthY), radius: cornerRadius, startAngle: isUp ? .pi/2 : .pi/2 * 3 , endAngle: 0, clockwise: !isUp)
        // 添加右侧竖线
        path.addLine(to: CGPoint(x: fifthX + cornerRadius, y: secondY + coefficient * cornerRadius))
        // 添加右侧顶端圆弧
        path.addArc(withCenter: CGPoint(x: fifthX,y: secondY + coefficient * cornerRadius), radius: cornerRadius, startAngle: 0, endAngle: isUp ? .pi/2 * 3 : .pi/2 , clockwise: !isUp)
        // 添加右侧横线至顶点位置
        path.addLine(to: CGPoint(x: secondX + arrowSize.width, y: secondY))
        path.close()
        // 构建mask路径
        let mask = CAShapeLayer()
        mask.frame = CGRect(origin: .zero, size: CGSize(width: contentSize.width, height: contentSize.height + arrowSize.height))
        mask.path = path.cgPath
        // 计算contentView的坐标
        let y = isUp ? arrowPoint.y : anchorRect.minY - contentSize.height - arrowSize.height
        let x = arrowPoint.x - arrowX
        contentView.frame = CGRect(x: x, y: y, width: contentSize.width, height: contentSize.height + arrowSize.height)
        contentView.layer.mask = mask
        // 修改contentView的锚点
        let position = contentView.layer.position
        var anchorPoint = contentView.layer.anchorPoint
        contentView.layer.position = arrowPoint
        anchorPoint.x += (arrowPoint.x - position.x)/contentView.bounds.width
        anchorPoint.y += (arrowPoint.y - position.y)/contentView.bounds.height
        contentView.layer.anchorPoint = anchorPoint
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first,touch.view == view  {
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
        switch type {
        case .present:
            let tempView = fromVC.view.snapshotView(afterScreenUpdates: false)!
            tempView.frame = fromVC.view.frame
            fromVC.view.isHidden = true
            containerView.addSubview(tempView)
            containerView.addSubview(toVC.view)
            toVC.view.frame = UIScreen.main.bounds
            if transitionContext.isAnimated {
                let duration = transitionDuration(using: transitionContext)
                let contentView = (toVC as! XHTriangleViewController).contentView
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.fromValue = 1.0
                let toValue = min(UIScreen.main.bounds.width/contentView.bounds.width, 1.2)
                scaleAnimation.toValue = toValue
                scaleAnimation.duration = duration/2
                scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                scaleAnimation.autoreverses = true
                contentView.layer.add(scaleAnimation, forKey: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
                    transitionContext.completeTransition(true)
                }
            } else {
                transitionContext.completeTransition(true)
            }
        case .dismiss:
            if transitionContext.isAnimated {
                let duration = transitionDuration(using: transitionContext)
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.fromValue = 1.0
                scaleAnimation.toValue = 0.01
                scaleAnimation.duration = duration
                scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                scaleAnimation.isRemovedOnCompletion = false
                scaleAnimation.fillMode = kCAFillModeForwards
                (fromVC as! XHTriangleViewController).contentView.layer.add(scaleAnimation, forKey: nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration, execute: {
                    if transitionContext.transitionWasCancelled {
                        transitionContext.completeTransition(false)
                    } else {
                        transitionContext.completeTransition(true)
                        toVC.view.isHidden = false
                    }
                })
            } else {
                transitionContext.completeTransition(true)
                toVC.view.isHidden = false
            }
        }
    }
}

