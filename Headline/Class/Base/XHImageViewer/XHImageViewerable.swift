//
//  XHImageViewerable.swift
//  Headline
//
//  Created by Li on 2018/3/26.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

protocol XHImageViewerable {
    
    func viewer(in imageView: UIImageView,placeholder: UIImage?)
    
}

class XHImageViewerObject: NSObject {
    
    var aspectRatio: CGFloat = 0
    
    private var placeholder: UIImage?
    
    init(imageViewerable: XHImageViewerable,placeholder: UIImage? = nil) {
        if placeholder != nil {
            self.placeholder = placeholder
        } else {
            if let name = imageViewerable as? UIImageName {
                self.placeholder = UIImage(named: name)
            } else if let image = imageViewerable as? UIImage {
                self.placeholder = image
            }
        }
        if let placeholder = self.placeholder {
            aspectRatio = placeholder.size.width/placeholder.size.height
        }
        self.imageViewerable = imageViewerable
    }
    
    private var imageViewerable: XHImageViewerable
    
    func viewer(in imageView: UIImageView) {
        imageViewerable.viewer(in: imageView, placeholder: placeholder)
    }
}

typealias UIImageName = String

extension UIImageName: XHImageViewerable {
    
    func viewer(in imageView: UIImageView, placeholder: UIImage?) {
        imageView.image = UIImage(named: self)
    }
}

extension UIImage: XHImageViewerable {
    
    func viewer(in imageView: UIImageView, placeholder: UIImage?) {
        imageView.image = self
    }
    
}

extension URL: XHImageViewerable {
    
    func viewer(in imageView: UIImageView, placeholder: UIImage?) {
        imageView.kf.setImage(with: self, placeholder: placeholder)
    }
    
}


class XHImageView: UIImageView {
    
    func setImageViewerObject(object: XHImageViewerObject,width: CGFloat) {
        object.viewer(in: self)
        let height = width/object.aspectRatio
        bounds = CGRect(x: 0, y: 0, width: width, height: height)
    }
    
}

