//
//  XHRefreshGifHeader.swift
//  News
//
//  Created by Li on 2018/2/26.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import MJRefresh

class XHRefreshGifHeader: MJRefreshGifHeader {

    override func prepare() {
        super.prepare()
        var images: [UIImage] = []
        for index in 0 ..< 16 {
            let name = String(format: "dragdown_loading_%02d", index)
            let image = UIImage(named: name)!
            images.append(image)
        }
        setImages(images, for: .idle)
        setImages(images, for: .refreshing)
        setTitle("下拉推荐", for: .idle)
        setTitle("松开推荐", for: .pulling)
        setTitle("推荐中", for: .refreshing)
        isAutomaticallyChangeAlpha = true
        lastUpdatedTimeLabel.isHidden = true
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        gifView.contentMode = .center
        stateLabel.font = UIFont.systemFont(ofSize: 12)
        gifView.frame = CGRect(x: 0, y: 4, width: bounds.width, height: 25)
        stateLabel.frame = CGRect(x: 0, y: 35, width: bounds.width, height: 14)
    }
    
}
