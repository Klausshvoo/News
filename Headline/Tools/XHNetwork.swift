//
//  XHNetwork.swift
//  Headline
//
//  Created by Li on 2018/3/13.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import Alamofire

let device_id: String = "41312231473"

let iid: String = "17769976909"

fileprivate let baseUrl = "https://is.snssdk.com"

enum XHNetworkResponse<T: Decodable> {
    case success(T),failure(XHNetworkError)
}

enum XHNetworkError {
    case noServer,noNet
}

class XHNetwork: NSObject {
    
    static let shared = XHNetwork()
    
    override init() {
        super.init()
        SessionManager.default.session.configuration.timeoutIntervalForRequest = 15
    }
    
    private func request<T>(_ url: String,method: HTTPMethod,parameters: Parameters?,cacheType: XHNetworkCacheType,response: @escaping (XHNetworkResponse<T>) -> Void) {
        let url = baseUrl + url
        let cacheInfo = cacheType.cacheInfo
        if cacheInfo != nil,let object = XHNetworkCache.shared.object(for: url, parameters: parameters) {
            let result = try! JSONDecoder().decode(T.self, from: object.data)
            response(.success(result))
            return
        }
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            switch dataResponse.result {
            case .success(let data):
                let result = try! JSONDecoder().decode(T.self, from: data)
                response(.success(result))
                cacheInfo?.cache(data: data, for: url, parameters: parameters)
            case .failure(let error):
                if let error = error as? URLError,error.errorCode == -1009 {
                    response(.failure(.noNet))
                } else {
                    response(.failure(.noServer))
                }
            }
        }
    }
    
    func get<T>(_ url: String,parameters: Parameters? = nil,cacheType: XHNetworkCacheType = .none,response: @escaping (XHNetworkResponse<T>) -> Void) {
        request(url, method: .get, parameters: parameters, cacheType: cacheType, response: response)
    }
    
    func post<T>(_ url: String,parameters: Parameters? = nil,cacheType: XHNetworkCacheType = .none,response: @escaping (XHNetworkResponse<T>) -> Void) {
        request(url, method: .post, parameters: parameters, cacheType: cacheType, response: response)
    }
    
}


// MARK: - 缓存机制

enum XHNetworkCacheType {
    
    case none,destination(XHCacheInfo)
    
    var cacheInfo: XHCacheInfo? {
        switch self {
        case .destination(let temp):
            return temp
        default:
            return nil
        }
    }
    
    enum Destination {
        case memory,disk
    }
    
    struct XHCacheInfo {
        
        var destination: Destination
        
        var duration: TimeInterval
        
        init(destination: Destination,duration: TimeInterval = 0) {
            self.destination = destination
            self.duration = duration
        }
        
        func cache(data: Data,for url: String,parameters: Parameters?) {
            XHNetworkCache.shared.cache(data, for: url, parameters: parameters, cacheInfo: self)
        }
    }
    
}

fileprivate class XHNetworkCache: NSObject {
    
    static let shared = XHNetworkCache()
    
    fileprivate let directoryPath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first! + "/org.app.Personal.NetworkCache"
    
    private(set) var isDiskCacheEnabel: Bool = true
    
    private lazy var diskCacheQueue: DispatchQueue = {
        return DispatchQueue(label: "networkDiskCache")
    }()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMemoryWarning), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
        cache.totalCostLimit = 20 * 1024 * 1024
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: directoryPath) {
            do {
                try fileManager.createDirectory(atPath: directoryPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
                isDiskCacheEnabel = false
            }
        }
        print(directoryPath)
    }
    
    private let cache: NSCache<NSString,XHNetworkCacheObject> = NSCache<NSString, XHNetworkCacheObject>()
    
    private func encodeKey(with url: String,parameters: Parameters?) -> NSString {
        var key: String = url
        if let parameters = parameters {
            let data = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            let json = String(data: data, encoding: .utf8)!
            key += json
        }
        return key as NSString
    }
    
    func object(for url: String,parameters: Parameters?) -> XHNetworkCacheObject? {
        let key = encodeKey(with: url, parameters: parameters)
        if let object = cache.object(forKey: key) {
            if !object.isInvalid {
                return object
            }
            cacheSize -= object.data.count
            cache.removeObject(forKey: key)
            return nil
        }
        if let data = read(at: key as String) {
            if let object = try? JSONDecoder().decode(XHNetworkCacheObject.self, from: data) {
                if !object.isInvalid {
                    cache.setObject(object, forKey: key, cost: data.count)
                    return object
                }
                try? FileManager.default.removeItem(atPath: directoryPath + "/\((key as String).md5)")
            }
        }
        return nil
    }
    
    private func read(at path: String) -> Data? {
        let filePath = XHNetworkCache.shared.directoryPath + "/\(path.md5)"
        let url = URL(fileURLWithPath: filePath)
        return try? Data.init(contentsOf: url)
    }
    
    @objc private func didReceiveMemoryWarning() {
        cache.removeAllObjects()
        cacheSize = 0
    }
    
    private(set) var cacheSize: Int = 0
    
    func cache(_ data: Data,for url: String,parameters: Parameters?,cacheInfo: XHNetworkCacheType.XHCacheInfo) {
        let key = encodeKey(with: url, parameters: parameters)
        var cacheObject: XHNetworkCacheObject
        if let object = cache.object(forKey: key),!object.isInvalid {
            cacheSize = cacheSize - object.data.count
            cacheObject = object
        } else {
            cacheObject = XHNetworkCacheObject(data: data)
            cache.setObject(cacheObject, forKey: key, cost: data.count)
        }
        cacheSize += data.count
        if cacheInfo.duration > 0 {
            cacheObject.invalidDate = Date().addingTimeInterval(cacheInfo.duration)
        }
        guard cacheInfo.destination == .disk else { return }
        diskCacheQueue.async {[weak self] in
            let objectData = try! JSONEncoder().encode(cacheObject)
            if !self!.write(objectData, to: key as String) {
                // 因无法创建文件夹或者无法写入数据造成无法进行持久性存储，该处是否进行上报或者记录
            }
        }
    }
    
    private func write(_ data: Data,to path: String) -> Bool {
        guard isDiskCacheEnabel else { return false }
        let filePath = directoryPath + "/\(path.md5)"
        return (data as NSData).write(toFile: filePath, atomically: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

fileprivate class XHNetworkCacheObject: NSObject,Codable {
    
    var data: Data
    
    var isInvalid: Bool {
        if let invalidDate = self.invalidDate {
            return invalidDate.compare(Date()) != .orderedAscending
        }
        return false
    }
    
    init(data: Data) {
        self.data = data
    }
    
    var invalidDate: Date?
    
}
