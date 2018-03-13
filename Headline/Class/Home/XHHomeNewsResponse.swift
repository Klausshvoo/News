//
//  XHHomeNewsResponse.swift
//  Headline
//
//  Created by Klaus on 2018/3/13.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

struct XHNewsResponse: Decodable {

    var data: [XHResponseContent]
    
    var total_number: Int
    
    var has_more: Bool
    
    var has_more_to_refresh: Bool
    
    var tips: XHResponseTip
    
}

struct XHResponseTip: Decodable {
    
    var display_info: String
    
    var display_duration: TimeInterval
    
}

struct XHResponseContent: Decodable {
    
    var content: String
    
}
