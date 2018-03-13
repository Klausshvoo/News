//
//  UIButton+Position.swift
//  News
//
//  Created by Li on 2018/2/25.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

extension UIButton {
    
    /// 如果调用该方法，系统的水平和垂直布局将无效，只能居中布局
    func setPositionStyle(_ style: XHButtonPositonStyle,padding: CGFloat) {
        xh_positonStyle = style
        xh_padding = padding
        guard bounds.size != .zero else {
            return
        }
        xh_size = bounds.size
        setPosition()
    }
    
    fileprivate func setPosition() {
        guard let currentImage = currentImage else {
            return
        }
        guard let currentTitle = currentTitle else {
            return
        }
        let titleSize = currentTitle.size(withAttributes: [.font: titleLabel!.font])
        let imageSize = currentImage.size
        switch xh_positonStyle! {
        case .normal:
            let width = min(imageSize.width + titleSize.width + xh_padding,bounds.width)
            let margin = (bounds.width - width)/2
            imageRect = CGRect(x: margin, y: (bounds.height - imageSize.height)/2, width: imageSize.width, height: imageSize.height)
            titleRect = CGRect(x: imageRect!.maxX + xh_padding, y: (bounds.height - titleSize.height)/2, width: width - xh_padding - imageSize.width, height: titleSize.height)
        case .horizontalOpposite:
            let width = min(imageSize.width + titleSize.width + xh_padding,bounds.width)
            let margin = (bounds.width - width)/2
            imageRect = CGRect(x: bounds.width - margin - imageSize.width, y: (bounds.height - imageSize.height)/2, width: imageSize.width, height: imageSize.height)
            titleRect = CGRect(x: margin, y: (bounds.height - titleSize.height)/2, width: width - xh_padding - imageSize.width, height: titleSize.height)
        case .vertical:
            let height = min(imageSize.height + titleSize.height + xh_padding,bounds.height)
            let margin = (bounds.height - height)/2
            imageRect = CGRect(x: (bounds.width - imageSize.width) / 2, y: margin, width: imageSize.width, height: imageSize.height)
            let titleWidth = min(titleSize.width, bounds.width)
            titleRect = CGRect(x: (bounds.width - titleWidth) / 2, y: imageRect!.maxY + xh_padding, width: titleWidth, height: titleSize.height)
        case .verticalOpposite:
            let height = min(imageSize.height + titleSize.height + xh_padding,bounds.height)
            let margin = (bounds.height - height)/2
            imageRect = CGRect(x: (bounds.width - imageSize.width) / 2, y: bounds.height - margin - imageSize.height, width: imageSize.width, height: imageSize.height)
            let titleWidth = min(titleSize.width, bounds.width)
            titleRect = CGRect(x: (bounds.width - titleWidth) / 2, y: margin, width: titleWidth, height: titleSize.height)
        }
    }
    
    static func positionEnabled() {
        exchangeInstanceSelector(#selector(titleRect(forContentRect:)), with: #selector(xh_titleRect(forContentRect:)))
        exchangeInstanceSelector(#selector(imageRect(forContentRect:)), with: #selector(xh_imageRect(forContentRect:)))
    }
    
    @objc private func xh_titleRect(forContentRect contentRect: CGRect) -> CGRect {
        if xh_positonStyle != nil && bounds.size != xh_size {
            xh_size = bounds.size
            setPosition()
        }
        if let titleRect = titleRect,titleRect != .zero {
            return titleRect
        }
        return xh_titleRect(forContentRect: contentRect)
    }
    
    @objc private func xh_imageRect(forContentRect contentRect: CGRect) -> CGRect {
        if xh_positonStyle != nil && bounds.size != xh_size {
            xh_size = bounds.size
            setPosition()
        }
        if let imageRect = imageRect,imageRect != .zero {
            return imageRect
        }
        return xh_imageRect(forContentRect: contentRect)
    }
    
    private static let titleRectKey = UnsafeRawPointer(bitPattern: "titleRectKey".hashValue)!
    
    private var titleRect: CGRect? {
        set {
            objc_setAssociatedObject(self, UIButton.titleRectKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, UIButton.titleRectKey) as? CGRect
        }
    }
    
    private static let imageRectKey = UnsafeRawPointer(bitPattern: "imageRectKey".hashValue)!
    
    private var imageRect: CGRect? {
        set {
            objc_setAssociatedObject(self, UIButton.imageRectKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
        get {
            return objc_getAssociatedObject(self, UIButton.imageRectKey) as? CGRect
        }
    }
    
    private static let xh_positonStyleKey = UnsafeRawPointer(bitPattern: "xh_positonStyleKey".hashValue)!
    
    private var xh_positonStyle: XHButtonPositonStyle? {
        get {
            return objc_getAssociatedObject(self, UIButton.xh_positonStyleKey) as? XHButtonPositonStyle
        }
        set {
            objc_setAssociatedObject(self, UIButton.xh_positonStyleKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
    private static let xh_paddingKey = UnsafeRawPointer(bitPattern: "xh_paddingKey".hashValue)!
    
    private var xh_padding: CGFloat {
        get {
            return objc_getAssociatedObject(self, UIButton.xh_paddingKey) as? CGFloat ?? 0
        }
        set {
            objc_setAssociatedObject(self, UIButton.xh_paddingKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    private static let xh_sizeKey = UnsafeRawPointer(bitPattern: "xh_sizeKey".hashValue)!
    
    private var xh_size: CGSize {
        get {
            return objc_getAssociatedObject(self, UIButton.xh_sizeKey) as? CGSize ?? .zero
        }
        set {
            objc_setAssociatedObject(self, UIButton.xh_sizeKey, newValue, .OBJC_ASSOCIATION_COPY)
        }
    }
    
}

enum XHButtonPositonStyle {
    
    case normal,horizontalOpposite,vertical,verticalOpposite
    
}

extension NSObject {
    
    class public func exchangeInstanceSelector(_ original: Selector,with swizzled: Selector) {
        let originalMethod = class_getInstanceMethod(self, original)!
        let swizzledMethod = class_getInstanceMethod(self, swizzled)!
        guard class_addMethod(self, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod)) else {
            method_exchangeImplementations(originalMethod, swizzledMethod)
            return
        }
        class_replaceMethod(self, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
    }
    
}
