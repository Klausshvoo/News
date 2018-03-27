//
//  XHPickerViewCell.swift
//  Headline
//
//  Created by Li on 2018/3/21.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHPickerViewCell: UITableViewCell {
    
    lazy var label: XHRenderLabel = {
        let temp = XHRenderLabel()
        contentView.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        temp.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        selectionStyle = .none
        temp.backgroundColor = UIColor.clear
        return temp
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class XHRenderLabel: UIView {
    
    var text: String = "" {
        didSet {
            if text != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    var font: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet {
            if font.pointSize != oldValue.pointSize {
                setNeedsDisplay()
            }
        }
    }
    
    var textColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var selectedTextColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var selectedRect: CGRect = .zero {
        didSet {
            if selectedRect != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    private var unselectedTextAttributes: [NSAttributedStringKey: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        return [.font: font,.foregroundColor: textColor,.paragraphStyle: paragraphStyle]
    }
    
    private var selectedTextAttributes: [NSAttributedStringKey: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineBreakMode = .byWordWrapping
        return [.font: font,.foregroundColor: selectedTextColor,.paragraphStyle: paragraphStyle]
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        let unselectedHeight = text.size(withAttributes: unselectedTextAttributes).height
        let unselectedRect = CGRect(x: rect.origin.x, y: rect.origin.y + (rect.height - unselectedHeight) / 2, width: rect.width, height: unselectedHeight)
        (text as NSString).draw(in: unselectedRect, withAttributes: unselectedTextAttributes)
        context?.restoreGState()
        if !selectedRect.isEmpty {
            context?.clip(to: selectedRect)
            (text as NSString).draw(in: unselectedRect, withAttributes: selectedTextAttributes)
        }
    }
}
