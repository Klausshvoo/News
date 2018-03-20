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
    
    var source: String?
    
    var filter_words: [XHFilterWords]?
    
    var read_count: Int = 0
    
    var share_url: String?
    
    var stick_label: String?
    
    var middle_image: XHImageModel?
    
    var video_style: Int = 0
    
    var has_video: Bool = false
    
    var large_image_list: [XHImageModel]?
    
    var image_list: [XHImageModel]?
    
    private var video_duration: TimeInterval?
    
    lazy var videoDuration: String? = {
        return video_duration?.durationString
    }()
    
    var video_detail_info: XHVideoDetailInfo?
    
    var user_info: XHUserInfo?
    
    private var publish_time: TimeInterval?
    
    var publishTime: String? {
        if let publish_time = self.publish_time {
            return Date.convert(timeIntervalSince1970: publish_time)
        }
        return nil
    }
    
    
    private var comment_count: Int = 0
    
    lazy var commentCountDescription: String = {
        if comment_count > 100000 {
            let int = comment_count / 10000
            return "\(int)万"
        }
        if comment_count > 10000 {
            let float = CGFloat(comment_count) / 10000
            return String(format: "%.1f万", float)
        }
        return "\(comment_count)"
    }()
    
    /// 有视频时，当video_style=0时在右侧显示小图middle_image,video_style=2显示大图large_image_list
    /// 没有视频时，先判断大图，再判断image_list，最后判断middle_image
}

struct XHImageModel: Decodable {
    
    var height: CGFloat
    
    var width: CGFloat
    
    private var url: String
    
    var path: String {
        if url.hasSuffix(".webp") {
            var temp = url
            let begin = temp.index(temp.endIndex, offsetBy: -5)
            temp.replaceSubrange(begin ..< temp.endIndex, with: ".jpg")
            return temp
        }
        return url
    }
}

class XHFilterWords: NSObject,Decodable {
    
    var id: String = ""
    
    var is_selected: Bool = false
    
    var name: String = ""
    
}

extension Date {
    
    static func convert(timeIntervalSince1970: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeIntervalSince1970)
        let timeInterval = -date.timeIntervalSinceNow
        if timeInterval < 60 {
            return "刚刚"
        }
        if timeInterval < 3600 {
            let miniter = Int(timeInterval) / 60
            return "\(miniter)分钟前"
        }
        if timeInterval < 3600 * 24 {
            let hour = Int(timeInterval) / 3600
            return "\(hour)小时前"
        }
        if timeInterval < 3600 * 24 * 2 {
            return "昨天"
        }
        if timeInterval < 3600 * 24 * 3 {
            return "前天"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
}

struct XHVideoDetailInfo: Decodable {
    
    var detail_video_large_image: XHImageModel
    
}

extension TimeInterval {
    
    var durationString: String {
        let duration = Int(self)
        let min = duration / 60
        let second = duration % 60
        return String(format: "%02d:%02d", min,second)
    }
}

class XHUserInfo: NSObject,Decodable {
    
    var avatar_url: String = ""
    
    var follow: Bool = false
    
    var follower_count: Int = 0
    
    var name: String = ""
    
    var user_id: Int = 0
    
    var user_verified: Bool = false

}


