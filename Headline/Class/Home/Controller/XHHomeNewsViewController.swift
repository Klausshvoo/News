//
//  XHHomeNewsViewController.swift
//  Headline
//
//  Created by Li on 2018/4/19.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHHomeNewsViewController: XHWebViewController {

    private var url: URL!
    
    private var isInteractive: Bool = false
    
    private var interactiveTransition: UIPercentDrivenInteractiveTransition = UIPercentDrivenInteractiveTransition()
    
    init(url: URL,javaScriptMethods methods: [String]?) {
        self.url = url
        super.init(javaScriptMethods: methods)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showProgress = true
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        webView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.backgroundColor = UIColor.white
        let request = URLRequest(url: url)
//        request.addValue(<#T##value: String##String#>, forHTTPHeaderField: <#T##String#>)
        webView.load(request)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(pan)
    }

    @objc private func handlePan(_ pan: UIPanGestureRecognizer) {
        var percent: CGFloat = 0
        let translationX = pan.translation(in: view).x
        percent = translationX/view.bounds.width
        switch pan.state {
        case .began:
            isInteractive = true
            dismiss(animated: true, completion: nil)
        case .changed:
            if percent > 0 {
                interactiveTransition.update(percent)
            } else {
                interactiveTransition.update(0)
            }
        case .ended:
            if percent > 0.5 {
                interactiveTransition.finish()
            } else {
                interactiveTransition.cancel()
            }
            isInteractive = false
        default:
            interactiveTransition.cancel()
            isInteractive = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension XHHomeNewsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return XHViewControllerPushTransitioning(transitioningType: .dismiss)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return XHViewControllerPushTransitioning(transitioningType: .present)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return isInteractive ? interactiveTransition : nil
    }
}

