//
//  XHPhotoManager.swift
//  Headline
//
//  Created by Klaus on 2018/3/27.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import Photos

class XHPhotoAlbum: NSObject {
    
    private(set) var count: Int = 0
    
    lazy var photos: [XHPhoto] = {
        var temp = [XHPhoto]()
        let result = PHAsset.fetchAssets(in: collection, options: nil)
        result.enumerateObjects({ (asset, _, _) in
            temp.append(XHPhoto(asset: asset))
        })
        return temp
    }()
    
    private var collection: PHAssetCollection
    
    init(collection: PHAssetCollection) {
        self.collection = collection
        super.init()
        if collection.assetCollectionType == .album {
            count = self.collection.estimatedAssetCount
        } else if collection.assetCollectionType == .smartAlbum {
            count = photos.count
        }
    }
    
    var localizedTitle: String? {
        return collection.localizedTitle
    }
    
    class func fetchAllAblums() -> [XHPhotoAlbum] {
        var ablums = [XHPhotoAlbum]()
        let options = PHFetchOptions()
        options.includeHiddenAssets = false
        let smartAblums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: options)
        smartAblums.enumerateObjects { (colletion, _, _) in
            if colletion.assetCollectionSubtype == .smartAlbumUserLibrary {
                ablums.insert(XHPhotoAlbum(collection: colletion), at: 0)
            } else {
                ablums.append(XHPhotoAlbum(collection: colletion))
            }
        }
        let userAblums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: nil)
        userAblums.enumerateObjects { (collection, _, _) in
            ablums.append(XHPhotoAlbum(collection: collection))
        }
        
        return ablums
    }
    
    class var userLibrary: XHPhotoAlbum {
        let smartAblum = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil).lastObject!
        return XHPhotoAlbum(collection: smartAblum)
    }
    
}

class XHPhoto: NSObject {
    
    private var asset: PHAsset
    
    init(asset: PHAsset) {
        self.asset = asset
        super.init()
    }
    
    private lazy var results: [XHPhotoResult] = []
    
    func fetchPhoto(in size: CGSize,completion: @escaping (UIImage?) -> Void) {
        let results = self.results.filter({ $0.size == size })
        if let result = results.first {
            result.closure = completion
            result.closure?(result.image)
        } else {
            let result = XHPhotoResult()
            result.size = size
            result.closure = completion
            let options = PHImageRequestOptions()
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .exact
            self.results.append(result)
            PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: options) { (image, _) in
                result.image = image
                result.closure?(image)
            }
        }
    }
    
    func closeClosure(for size: CGSize) {
        let results = self.results.filter({ $0.size == size })
        if let result = results.first {
            result.closure = nil
        }
    }
}

private class XHPhotoResult: NSObject {
    
    var size: CGSize = .zero
    
    var closure: ((UIImage?) -> Void)?
    
    var image: UIImage?
    
}
/*
 case smartAlbumPanoramas 全景照片 201 2
 
 case smartAlbumVideos 视频 202  7
 
 case smartAlbumFavorites 个人收藏 203 10
 
 case smartAlbumTimelapses 延时摄影 204 3
 
 case smartAlbumRecentlyAdded 最近添加 206 9
 
 case smartAlbumBursts 连拍快照 207 5
 
 case smartAlbumSlomoVideos 慢动作 208 1
 
 case smartAlbumUserLibrary 相机胶卷 209 0
 
 case smartAlbumSelfPortraits 自拍 210 4
 
 case smartAlbumScreenshots 屏幕快照 211 8
 
                              人像 212 6

 case smartAlbumLivePhotos 实况照片 213 11
 
 case smartAlbumAnimated 动图 215 13
 
 case smartAlbumLongExposures 长曝光 215 12
 */
