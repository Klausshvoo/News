//
//  XHFixedSpaceLayout.swift
//  Headline
//
//  Created by Li on 2018/4/2.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

/// fixedSpace should be set in property,for example: sectionInset,minimumLineSpacing,minimumInteritemSpacing
class XHFixedSpaceLayout: UICollectionViewFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        if let attributes = attributes,!attributes.isEmpty {
            let cellAttributes = attributes.filter({$0.representedElementCategory == .cell })
            if !cellAttributes.isEmpty {
                var front = attributes[0]
                if front.indexPath.item == 0 && front.frame.minX != sectionInset.left {
                    front.frame = CGRect(origin: CGPoint(x: sectionInset.left, y: front.frame.minY), size: front.size)
                }
                for index in 1 ..< attributes.count {
                    let attribute = attributes[index]
                    if attribute.frame.minY == front.frame.minY {
                        let x = front.frame.maxX + minimumInteritemSpacing
                        attribute.frame = CGRect(x: x, y: attribute.frame.minY, width: attribute.frame.width, height: attribute.frame.height)
                    } else if attribute.frame.minX != sectionInset.left {
                        attribute.frame = CGRect(x: sectionInset.left, y: attribute.frame.minY, width: attribute.frame.width, height: attribute.frame.height)
                    }
                    front = attribute
                }
            }
        }
        return attributes
    }
    
}
