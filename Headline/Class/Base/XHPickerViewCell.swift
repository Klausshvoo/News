//
//  XHPickerViewCell.swift
//  Headline
//
//  Created by Li on 2018/3/21.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHPickerViewCell: UITableViewCell {
    
    private let label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.clear
        contentView.addSubview(label)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String) {
        label.text = text
    }
}

class XHRenderLabel: UIView {
    
    var text: String?
    
    var font: UIFont = UIFont.systemFont(ofSize: 14)
    
    var textColor: UIColor = UIColor.black
    
    var selectedTextColor: UIColor = UIColor.red
    
    var selectedProgress: CGFloat = 0
    
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
//        CGFloat unselectedTextRectHeight = [self.text boundingRectWithSize:rect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:self.unselectedTextAttributes context:nil].size.height;
//        
//        CGRect unselectedTextDrawingRect = CGRectMake(rect.origin.x,
//                                                      rect.origin.y + (rect.size.height - unselectedTextRectHeight) / 2.0f,
//                                                      rect.size.width,
//                                                      unselectedTextRectHeight);
//        
//        [self.text drawInRect:unselectedTextDrawingRect withAttributes:self.unselectedTextAttributes];
//        
//        CGContextRestoreGState(context);
//        
//        if (!CGRectIsEmpty(self.selectedTextDrawingRect)) {
//            
//            CGFloat selectedTextRectHeight = [self.text boundingRectWithSize:rect.size options:NSStringDrawingUsesLineFragmentOrigin attributes:self.selectedTextAttributes context:nil].size.height;
//            
//            CGRect selectedTextDrawingRect = CGRectMake(rect.origin.x,
//                                                        rect.origin.y + (rect.size.height - selectedTextRectHeight) / 2.0f,
//                                                        rect.size.width,
//                                                        selectedTextRectHeight);
//            CGContextClipToRect(context, self.selectedTextDrawingRect);
//            
//            [self.text drawInRect:selectedTextDrawingRect withAttributes:self.selectedTextAttributes];
//        }
    }
}
