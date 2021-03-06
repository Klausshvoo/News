//
//  XHImagePickerController.swift
//  Headline
//
//  Created by Li on 2018/3/26.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHImageViewerController: UIViewController {
    
    private var images: [XHImageViewerObject]
    
    private var presentView: UIImageView
    
    private var orignalIndex: Int = 0
    
    fileprivate var isChanged: Bool {
        let selectedIndex = Int(collectionView.contentOffset.x / view.bounds.width)
        return orignalIndex != selectedIndex
    }
    
    fileprivate lazy var tempView: XHImageView = {
       let temp = XHImageView()
        temp.isHidden = true
        temp.contentMode = .scaleAspectFit
        temp.setImageViewerObject(object: images[orignalIndex], width: view.bounds.width)
        temp.center = view.center
        return temp
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
       let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = UIScreen.main.bounds.size
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        let temp = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        temp.dataSource = self
        temp.delegate = self
        temp.register(XHImageViewerCell.self, forCellWithReuseIdentifier: "cell")
        temp.isPagingEnabled = true
        temp.isHidden = true
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.contentOffset = CGPoint(x: UIScreen.main.bounds.width * CGFloat(orignalIndex), y: 0)
        view.addSubview(tempView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        let currentItem = Int(collectionView.contentOffset.x / view.bounds.width)
        let cell = collectionView.cellForItem(at: IndexPath(item: currentItem, section: 0)) as! XHImageViewerCell
        let imageView = cell.scrollView.imageView
        tempView.image = imageView.image
        tempView.frame = imageView.convert(imageView.bounds, to: tempView.window)
        tempView.isHidden = false
        collectionView.isHidden = true
        super.dismiss(animated: flag, completion: completion)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.isHidden = false
        tempView.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(images: [XHImageViewerObject],with target: UIImageView,at index: Int) {
        self.images = images
        self.presentView = target
        self.orignalIndex = index
        super.init(nibName: nil, bundle: nil)
        transitioningDelegate = self
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension XHImageViewerController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

extension XHImageViewerController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! XHImageViewerCell
        cell.setImageViewerable(source: images[indexPath.row])
        return cell
    }
    
}

extension XHImageViewerController: UICollectionViewDelegate {
    
}

extension XHImageViewerController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let dismiss = XHImageViewerControllerTransition(transitioningType: .dismiss)
        dismiss.presentView = presentView
        return dismiss
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let present = XHImageViewerControllerTransition(transitioningType: .present)
        present.presentView = presentView
        return present
    }
    
}

fileprivate class XHImageViewerControllerTransition: XHViewControllerAnimatedTransitioning {
    
    var presentView: UIView!
    
    override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: .from)!
        let toVC = transitionContext.viewController(forKey: .to)!
        let containerView = transitionContext.containerView
        switch type {
        case .present:
            containerView.addSubview(toVC.view)
            toVC.view.alpha = 0
            let tempView = (toVC as! XHImageViewerController).tempView
            let toRect = tempView.frame
            let fromRect = presentView.convert(presentView.bounds, to: containerView)
            let snapView = snapViewFrom(view: presentView)
            snapView.frame = fromRect
            containerView.addSubview(snapView)
            presentView.isHidden = true
            if transitionContext.isAnimated {
                UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                    fromVC.view.alpha = 0
                    toVC.view.alpha = 1
                    snapView.frame = toRect
                }, completion: { (_) in
                    snapView.removeFromSuperview()
                    tempView.isHidden = false
                    transitionContext.completeTransition(true)
                })
            }
        case .dismiss:
            let isChanged = (fromVC as! XHImageViewerController).isChanged
            let tempView = (fromVC as! XHImageViewerController).tempView
            containerView.addSubview(tempView)
            if !isChanged {
                let toRect = presentView.convert(presentView.bounds, to: containerView)
                if transitionContext.isAnimated {
                    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                        tempView.frame = toRect
                        fromVC.view.alpha = 0
                        toVC.view.alpha = 1
                    }, completion: { [weak self](_) in
                        tempView.removeFromSuperview()
                        self?.presentView.isHidden = false
                        transitionContext.completeTransition(true)
                    })
                }
            } else {
                if transitionContext.isAnimated {
                    presentView.isHidden = false
                    UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
                        fromVC.view.alpha = 0
                        tempView.alpha = 0
                        toVC.view.alpha = 1
                    }, completion: { (_) in
                        tempView.removeFromSuperview()
                        transitionContext.completeTransition(true)
                    })
                }
            }
            
        }
    }
    
    private func snapViewFrom(view: UIView) -> UIView {
        let snpaView = UIView()
        snpaView.frame = view.frame
        if let view = view as? UIImageView {
            snpaView.layer.contents = view.image?.cgImage
        }
        return snpaView
    }
    
}



