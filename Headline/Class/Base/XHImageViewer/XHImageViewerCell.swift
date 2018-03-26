//
//  XHImageViewerCell.swift
//  Headline
//
//  Created by Li on 2018/3/26.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHImageViewerCell: UICollectionViewCell {
    
    private let scrollView = XHImageViewerScrollView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollView)
        scrollView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageViewerable(source: XHImageViewerable) {
        scrollView.setImageViewerable(source: source)
    }
}

class XHImageViewerScrollView: UIScrollView,UIScrollViewDelegate {
    
    let imageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
        
        imageView.contentMode = .scaleAspectFit
        delegate = self
        maximumZoomScale = 2.5
        minimumZoomScale = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        didSet {
            contentSize = frame.size
        }
    }
    
    func setImageViewerable(source: XHImageViewerable) {
        if let source  = source as? String {
            let image = UIImage(named: source)
            imageView.image = image
            let scale = image!.size.width / frame.width
            let height = image!.size.height/scale
            imageView.bounds = CGRect(origin: .zero, size: CGSize(width: frame.width, height: height))
            contentSize = CGSize(width: frame.width, height: height)
            if height > frame.height {
                contentInset = .zero
            } else {
                contentInset = UIEdgeInsets(top: (frame.height - height) / 2, left: 0, bottom: (frame.height - height) / 2, right: 0)
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var height = imageView.bounds.height * scrollView.zoomScale
        if height > frame.height {
            height = 0
        }
        contentInset = UIEdgeInsets(top: (frame.height - height) / 2, left: 0, bottom: (frame.height - height) / 2, right: 0)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.center = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
    }
}
