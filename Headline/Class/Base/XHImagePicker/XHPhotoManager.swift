//
//  XHPhotoManager.swift
//  Headline
//
//  Created by Klaus on 2018/3/27.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import Photos

class XHPhotoManager: NSObject {
    
    func fetchAllPhotos() {
        let roll = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
        roll.enumerateObjects { (collection, count, _) in
            let photos = PHAsset.fetchAssets(in: collection, options: nil)
            print("\(collection.localizedTitle!) --\(photos.count)")
        }
        let userRoll = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
        userRoll.enumerateObjects { (collection, _, _) in
            print("\(collection.localizedTitle!) --\(collection.estimatedAssetCount)")
        }
        
    }
    
}
/*
 
 case smartAlbumPanoramas 全景照片 201
 
 case smartAlbumVideos 视频 202
 
 case smartAlbumFavorites 个人收藏 203
 
 case smartAlbumTimelapses 延时摄影 204
 
 case smartAlbumRecentlyAdded 最近添加 206
 
 case smartAlbumBursts 连拍快照 207
 
 case smartAlbumSlomoVideos 慢动作 208
 
 case smartAlbumUserLibrary 相机胶卷 209
 
 @available(iOS 9.0, *)
 case smartAlbumSelfPortraits 自拍 210
 
 @available(iOS 9.0, *)
 case smartAlbumScreenshots 屏幕快照 211
 
 @available(iOS 10.3, *)
 case smartAlbumLivePhotos 实况照片 213
 
 @available(iOS 11.0, *)
 case smartAlbumAnimated 动图 215
 
 @available(iOS 11.0, *)
 case smartAlbumLongExposures 长曝光 215
 
 人像 212
 */
