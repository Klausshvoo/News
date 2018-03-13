//
//  XHRefreshGifFooter.swift
//  News
//
//  Created by Li on 2018/2/26.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import MJRefresh

class XHRefreshGifFooter: MJRefreshAutoGifFooter {
    
    override func prepare() {
        super.prepare()
        mj_h = 50
        var images = [UIImage]()
        for index in 0 ..< 8 {
            let image = UIImage(named: "dragloading_\(index)")!
            images.append(image)
        }
        setImages(images, for: .idle)
        setImages(images, for: .refreshing)
        setTitle("上拉加载数据", for: .idle)
        setTitle("正在努力加载", for: .pulling)
        setTitle("正在努力加载", for: .refreshing)
        setTitle("没有更多数据啦", for: .noMoreData)
        isAutomaticallyChangeAlpha = true
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        gifView.mj_x = 135
        gifView.center = CGPoint(x: gifView.center.x, y: stateLabel.center.y)
    }
    
}
