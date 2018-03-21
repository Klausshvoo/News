//
//  XHPickerViewLayout.swift
//  Headline
//
//  Created by Li on 2018/3/21.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

enum XHPickerViewIndicatorStyle {
    case `default`,`break`,highlight,custom
}

class XHPickerViewLayout: NSObject {

    var indicatorStyle: XHPickerViewIndicatorStyle = .default
    
    var rowHeight: CGFloat = 44
    
    var minimumLineSpacing: CGFloat = 0
    
    var minimumInteritemSpacing: CGFloat = 0
    
    var componentInset: UIEdgeInsets = .zero
    
}

protocol XHPickerViewDelegateLayout {
    
}
