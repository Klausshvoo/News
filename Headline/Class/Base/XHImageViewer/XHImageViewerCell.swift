//
//  XHImageViewerCell.swift
//  Headline
//
//  Created by Li on 2018/3/26.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHImageViewerCell: UICollectionViewCell {
    
    let scrollView = XHImageViewerScrollView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollView)
        scrollView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageViewerable(source: XHImageViewerObject) {
        scrollView.setImageViewerable(source: source)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
}

class XHImageViewerScrollView: UIScrollView,UIScrollViewDelegate {
    
    let imageView: XHImageView = XHImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
        imageView.contentMode = .scaleAspectFit
        delegate = self
        maximumZoomScale = 2.0
        minimumZoomScale = 1.0
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
        imageView.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var frame: CGRect {
        didSet {
            contentSize = frame.size
        }
    }
    
    @objc private func handleDoubleTap() {
        if zoomScale == minimumZoomScale {
            zoomScale = maximumZoomScale
        } else {
            zoomScale = minimumZoomScale
        }
    }
    
    func setImageViewerable(source: XHImageViewerObject) {
        imageView.setImageViewerObject(object: source, width: frame.width)
        let height = imageView.bounds.height
        contentSize = CGSize(width: frame.width, height: height)
        if height > frame.height {
            contentInset = .zero
        } else {
            contentInset = UIEdgeInsets(top: (frame.height - height) / 2, left: 0, bottom: (frame.height - height) / 2, right: 0)
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var height = imageView.bounds.height * scrollView.zoomScale
        if height > frame.height {
            height = frame.height
        }
        contentInset = UIEdgeInsets(top: (frame.height - height) / 2, left: 0, bottom: (frame.height - height) / 2, right: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.center = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
    }
    
}
