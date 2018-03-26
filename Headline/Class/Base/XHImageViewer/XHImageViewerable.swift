//
//  XHImageViewerable.swift
//  Headline
//
//  Created by Li on 2018/3/26.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

protocol XHImageViewerable {
    
    func setsource(for imageView: UIImageView)
    
}

extension String: XHImageViewerable{
    
    func setsource(for imageView: UIImageView) {
        
    }
}

extension UIImage: XHImageViewerable{
    
    func setsource(for imageView: UIImageView) {
        imageView.image = self
    }
}

extension URL: XHImageViewerable{
    
    func setsource(for imageView: UIImageView) {
        
    }
}
