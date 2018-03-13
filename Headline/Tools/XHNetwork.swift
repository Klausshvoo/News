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
    
    private func request<T>(_ url: String,method: HTTPMethod,parameters: Parameters?,isReadCache flag: Bool,response: @escaping (XHNetworkResponse<T>) -> Void) {
        let url = baseUrl + url
        if flag,let object = XHNetworkCache.shared.object(for: url, parameters: parameters) {
            let result = try! JSONDecoder().decode(T.self, from: object.data)
            response(.success(result))
            return
        }
        Alamofire.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
            switch dataResponse.result {
            case .success(let data):
                let result = try! JSONDecoder().decode(T.self, from: data)
                response(.success(result))
                if flag {
                    XHNetworkCache.shared.saveData(data, for: url, parameters: parameters)
                }
            case .failure(let error):
                if let error = error as? URLError,error.errorCode == -1009 {
                    response(.failure(.noNet))
                } else {
                    response(.failure(.noServer))
                }
            }
        }
    }
    
    func get<T>(_ url: String,parameters: Parameters? = nil,isReadCache flag: Bool = false,response: @escaping (XHNetworkResponse<T>) -> Void) {
        request(url, method: .get, parameters: parameters, isReadCache: flag, response: response)
    }
    
    func post<T>(_ url: String,parameters: Parameters? = nil,isReadCache flag: Bool = false,response: @escaping (XHNetworkResponse<T>) -> Void) {
        request(url, method: .post, parameters: parameters, isReadCache: flag, response: response)
    }
}


// MARK: - 缓存机制
fileprivate class XHNetworkCache: NSObject {
    
    static let shared = XHNetworkCache()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMemoryWarning), name: .UIApplicationDidReceiveMemoryWarning, object: nil)
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
    
    func saveData(_ data: Data, for url: String,parameters: Parameters?) {
        let key = encodeKey(with: url, parameters: parameters)
        if let object = cache.object(forKey: key),!object.isInvalid {
            object.update(data: data)
        } else {
            let object = XHNetworkCacheObject(data: data)
            cache.setObject(object, forKey: key)
        }
    }
    
    func object(for url: String,parameters: Parameters?) -> XHNetworkCacheObject? {
        let key = encodeKey(with: url, parameters: parameters)
        if let object = cache.object(forKey: key) {
            if !object.isInvalid {
                return object
            }
            cache.removeObject(forKey: key)
        }
        return nil
    }
    
    @objc private func didReceiveMemoryWarning() {
        cache.removeAllObjects()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

fileprivate class XHNetworkCacheObject: NSObject {
    
    var data: Data
    
    private var updateTime: Date
    
    var isInvalid: Bool {
        let invalidDate = updateTime.addingTimeInterval(300)
        return invalidDate.compare(Date()) != .orderedAscending
    }
    
    init(data: Data) {
        self.data = data
        updateTime = Date()
    }
    
    func update(data: Data) {
        updateTime = Date()
        self.data = data
    }
}
