//
//  XHHomeNews.swift
//  Headline
//
//  Created by Klaus on 2018/3/13.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHHomeNews: NSObject,Decodable {
    
    var abstract: String!
    
    var title: String?
    
    var media_name: String?
    
    private var publish_time: TimeInterval?
    
    var filter_words: [XHFilterWords]?
    
    var read_count: Int = 0
    
    var share_url: String?
    
    var stick_label: String?
    
    var middle_image: XHImageModel?
    
    var video_style: Int = 0
    
    var has_video: Bool = false
    
    var large_image_list: [XHImageModel]?
    
    var image_list: [XHImageModel]?
    
    var video_duration: TimeInterval?
    
    /// 有视频时，当video_style=0时在右侧显示小图middle_image,video_style=2显示大图large_image_list
    /// 没有视频时，先判断大图，再判断image_list，最后判断middle_image
}

struct XHImageModel: Decodable {
    
    var height: CGFloat
    
    var width: CGFloat
    
    var url: String
}

struct XHFilterWords: Decodable {
    
    var id: String
    
    var is_selected: Bool
    
    var name: String
    
}
