//
//  XHHomeChannel.swift
//  Headline
//
//  Created by Li on 2018/3/13.
//  Copyright © 2018年 Personal. All rights reserved.
//

import Foundation

class XHHomeChannel: NSObject,Decodable {
    
    var isAdd: Bool
    
    var concern_id: String
    
    var name: String
    
    var category: XHChannelCategory
    
    private enum CodingKeys: String,CodingKey {
        case default_add,concern_id,icon_url,name,category
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let add = try container.decode(Int.self, forKey: .default_add)
        self.isAdd = add == 1
        concern_id = try container.decode(String.self, forKey: .concern_id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(XHChannelCategory.self, forKey: .category)
    }
    
    enum XHChannelCategory: String,Codable {
        /// 推荐
        case recommend = "__all__"
        /// 热点
        case hot = "news_hot"
        /// 地区
        case local = "news_local"
        /// 视频
        case video = "video"
        /// 社会
        case society = "news_society"
        /// 图片,组图
        case photos = "组图"
        /// 娱乐
        case entertainment = "news_entertainment"
        /// 科技
        case newsTech = "news_tech"
        /// 科技
        case car = "news_car"
        /// 财经
        case finance = "news_finance"
        /// 军事
        case military = "news_military"
        /// 体育
        case sports = "news_sports"
        /// 段子
        case essayJoke = "essay_joke"
        /// 街拍
        case imagePPMM = "image_ppmm"
        /// 趣图
        case imageFunny = "image_funny"
        /// 美图
        case imageWonderful = "image_wonderful"
        /// 国际
        case world = "news_world"
        /// 搞笑
        case funny = "funny"
        /// 健康
        case health = "news_health"
        /// 特卖
        case jinritemai = "jinritemai"
        /// 房产
        case house = "news_house"
        /// 时尚
        case fashion = "news_fashion"
        /// 历史
        case history = "news_history"
        /// 育儿
        case baby = "news_baby"
        /// 数码
        case digital = "digital"
        /// 语录
        case essaySaying = "essay_saying"
        /// 星座
        case astrology = "news_astrology"
        /// 辟谣
        case rumor = "rumor"
        /// 正能量
        case positive = "positive"
        /// 动漫
        case comic = "news_comic"
        /// 故事
        case story = "news_story"
        /// 收藏
        case collect = "news_collect"
        /// 精选
        case boutique = "boutique"
        /// 孕产
        case pregnancy = "pregnancy"
        /// 文化
        case culture = "news_culture"
        /// 游戏
        case game = "news_game"
        /// 股票
        case stock = "stock"
        /// 科学
        case science = "science_all"
        /// 宠物
        case pet = "宠物"
        /// 情感
        case emotion = "emotion"
        /// 家居
        case home = "news_home"
        /// 教育
        case education = "news_edu"
        /// 三农
        case agriculture = "news_agriculture"
        /// 美食
        case food = "news_food"
        /// 养生
        case regimen = "news_regimen"
        /// 电影
        case movie = "movie"
        /// 手机
        case cellphone = "cellphone"
        /// 旅行
        case travel = "news_travel"
        /// 问答
        case questionAndAnswer = "question_and_answer"
        /// 小说
        case novelChannel = "novel_channel"
        /// 直播
        case live_talk = "live_talk"
        /// 中国新唱将
        case chinaSinger = "中国新唱将"
        /// 火山直播
        case hotsoon = "hotsoon"
        /// 互联网法院
        case highCourt = "high_court"
        /// 快乐男声
        case happyBoy = "快乐男声"
        /// 传媒
        case media = "media"
        /// 百万英雄
        case millionHero = "million_hero"
        /// 彩票
        case lottery = "彩票"
        /// 中国好表演
        case chinaAct = "中国好表演"
        /// 春节
        case springFestival = "spring_festival"
        /// 微头条
        case weitoutiao = "weitoutiao"
        /// 小视频 推荐
        case hotsoonVideo = "hotsoon_video"
        /// 小视频 颜值/美女
        case ugcVideoBeauty = "ugc_video_beauty"
        /// 小视频 随拍
        case ugcVideoCasual = "ugc_video_casual"
        /// 小视频 美食
        case ugcVideoFood = "ugc_video_food"
        /// 小视频 户外
        case ugcVideoLife = "ugc_video_life"
    }
    
    static func queryChannels(completion: @escaping ([XHHomeChannel]?) -> Void) {
        XHNetwork.shared.get("/article/category/get_subscribed/v1/?", parameters: ["device_id": device_id,"iid": iid], isReadCache: false) { (response: XHNetworkResponse<Result>) in
            switch response {
            case .success(let result):
                completion(result.data.data)
            case .failure(_):
                print("网络请求错误")
            }
        }
    }
    
}

fileprivate struct Result: Decodable {
    
    var data: ResultData
    
    struct ResultData: Decodable {
        
        var data : [XHHomeChannel]
        
    }
    
}

enum XHRefreshType {
    case auto,header,footer
}

extension XHHomeChannel.XHChannelCategory {
    
    func queryNews(refreshType: XHRefreshType,completion: @escaping (XHNewsResponse?) -> Void) {
        XHNetwork.shared.get("/api/news/feed/v58/?", parameters: ["device_id": device_id,"iid": iid,"category": rawValue,"device_platform": "iphone","version_code": "6.2.7"], isReadCache: true) { (response: XHNetworkResponse<XHNewsResponse>) in
            switch response {
            case .success(let result):
                completion(result)
            case .failure(_):
                print("网络请求错误")
            }
        }
    }
}

