//
//  UITableView+AutoHeightCell.swift
//  Headline
//
//  Created by Li on 2018/3/14.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

fileprivate class XHAutoHeightCellManager: NSObject {
    
    var contentViewWidth: CGFloat = 0 {
        didSet {
            clearCache()
        }
    }
    
    weak var tableView: UITableView?
    
    var cache: [IndexPath: CGFloat] = [:]
    
    var modelCells: [String: UITableViewCell] = [:]
    
    private func registerCell(cellClass: AnyClass) {
        let identifier = NSStringFromClass(cellClass)
        tableView?.register(cellClass, forCellReuseIdentifier: identifier)
        if let modelCell = tableView?.dequeueReusableCell(withIdentifier: identifier) {
            modelCells.updateValue(modelCell, forKey: identifier)
        }
    }
    
    func clearCache() {
        cache.removeAll()
        modelCells.removeAll()
    }
    
    func clearCache(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            cache.removeValue(forKey: indexPath)
        }
    }
    
    func deleteCache(at indexPaths: [IndexPath]) {
        var tempIndexPaths: [IndexPath: (Int,CGFloat)] = [:]
        for indexPath in indexPaths {
            cache.removeValue(forKey: indexPath)
            tempIndexPaths.removeValue(forKey: indexPath)
            let filter = cache.filter{ $0.key.section == indexPath.section && $0.key.row > indexPath.row }
            for (nextIndexPath,value) in filter {
                if let count = tempIndexPaths[nextIndexPath]?.0 {
                    tempIndexPaths.updateValue((count + 1,value), forKey: nextIndexPath)
                } else {
                    tempIndexPaths.updateValue((1,value), forKey: nextIndexPath)
                }
            }
        }
        for (indexPath,_) in tempIndexPaths {
            cache.removeValue(forKey: indexPath)
        }
        for (indexPath,(count,value)) in tempIndexPaths {
            cache.updateValue(value, forKey: IndexPath(row: indexPath.row - count, section: indexPath.section))
        }
    }
    
    func insertCache(at indexPaths:[IndexPath]) {
        var sections: [Int: [Int]] = [:]
        for indexPath in indexPaths {
            let section = indexPath.section
            if let arr = sections[section] {
                var rows = arr
                rows.append(indexPath.row)
                sections[section] = rows
            } else {
                let rows = [indexPath.row]
                sections[section] = rows
            }
        }
        for (section,rows) in sections {
            var heightsTemp = [CGFloat?]()
            let count = tableView!.numberOfRows(inSection: section)
            for index in 0 ..< count {
                let indexPath = IndexPath(row: index, section: section)
                if let height = cache[indexPath] {
                    heightsTemp.append(height)
                } else {
                    heightsTemp.append(nil)
                }
            }
            let rows = rows.sorted()
            for row in rows {
                heightsTemp.insert(nil, at: row)
            }
            for index in 0 ..< heightsTemp.count {
                let indexPath = IndexPath(row: index, section: section)
                if let height = heightsTemp[index] {
                    cache.updateValue(height, forKey: indexPath)
                } else {
                    cache.removeValue(forKey: indexPath)
                }
            }
        }
    }
    
    func reloadSections(_ sections: IndexSet) {
        for indexPath in cache.keys {
            if sections.contains(indexPath.section) {
                cache.removeValue(forKey: indexPath)
            }
        }
    }
    
    private func heightForIndexPath(_ indexPath: IndexPath) -> CGFloat? {
        return cache[indexPath]
    }
    
    func cellHeight<T: UITableViewCell>(for indexPath: IndexPath,execute: (T) -> Void) -> CGFloat {
        if let height = heightForIndexPath(indexPath) {
            return height
        }
        let identifier = NSStringFromClass(T.self)
        var modelCell = modelCells[identifier]
        if modelCell == nil {
            registerCell(cellClass: T.self)
            modelCell = modelCells[identifier]
        }
        if modelCell!.contentView.bounds.width != contentViewWidth {
            modelCell?.contentView.frame = CGRect(x: modelCell!.frame.minX, y: modelCell!.frame.minY, width: contentViewWidth, height: modelCell!.frame.height)
        }
        execute(modelCell as! T)
        modelCell?.contentView.layoutSubviews()
        var height = modelCell!.bottomMargin
        var maxY: CGFloat = 0
        for bottomView in modelCell!.bottomViews {
            maxY = max(maxY, bottomView.frame.maxY)
        }
        height += maxY
        cache.updateValue(height, forKey: indexPath)
        return height
    }
    
}

protocol XHTableViewCellAutoHeight: NSObjectProtocol {}

extension XHTableViewCellAutoHeight where Self: UITableViewCell {
    
    func setAutoHeight(bottomView: UIView, bottomMargin: CGFloat) {
        self.bottomViews = [bottomView]
        self.bottomMargin = bottomMargin
    }
    
    func setAutoHeight(bottomViews: [UIView], bottomMargin: CGFloat) {
        self.bottomViews = bottomViews
        self.bottomMargin = bottomMargin
    }
}

extension UITableViewCell {
    
    private static let bottomViewKey = UnsafeRawPointer(bitPattern: "bottomViewKey".hashValue)!
    
    fileprivate var bottomViews: [UIView] {
        get {
            return objc_getAssociatedObject(self, UITableViewCell.bottomViewKey) as! [UIView]
        }
        set {
            objc_setAssociatedObject(self, UITableViewCell.bottomViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private static let bottomMarginKey = UnsafeRawPointer(bitPattern: "bottomMarginKey".hashValue)!
    
    fileprivate var bottomMargin: CGFloat {
        get {
            return objc_getAssociatedObject(self, UITableViewCell.bottomMarginKey) as? CGFloat ?? 0
        }
        set {
            objc_setAssociatedObject(self, UITableViewCell.bottomMarginKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
}

class XHAutoHeightCellTableView: UITableView {
    
    fileprivate lazy var autoHeightManager: XHAutoHeightCellManager = {
        let temp = XHAutoHeightCellManager()
        temp.tableView = self
        return temp
    }()
    
    func cellHeight<T: UITableViewCell>(for indexPath: IndexPath,execute: (T)-> Void) -> CGFloat {
        if autoHeightManager.contentViewWidth != bounds.width {
            autoHeightManager.contentViewWidth = bounds.width
        }
        return autoHeightManager.cellHeight(for: indexPath, execute: execute)
    }
    
    override func reloadData() {
        autoHeightManager.clearCache()
        super.reloadData()
    }
    
    override func reloadRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        autoHeightManager.clearCache(at: indexPaths)
        super.reloadRows(at: indexPaths, with: animation)
    }
    
    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        autoHeightManager.deleteCache(at: indexPaths)
        super.deleteRows(at: indexPaths, with: animation)
    }
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation) {
        autoHeightManager.insertCache(at: indexPaths)
        super.insertRows(at: indexPaths, with: animation)
    }
    
    override func reloadSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        autoHeightManager.reloadSections(sections)
        super.reloadSections(sections, with: animation)
    }
    
    override func deleteSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        super.deleteSections(sections, with: animation)
    }
    
    override func insertSections(_ sections: IndexSet, with animation: UITableViewRowAnimation) {
        super.insertSections(sections, with: animation)
    }
    
}

extension UITableView {
    
    func update(_ closer: () -> Void,completion: ((Bool) -> Void)? = nil) {
        if #available(iOS 11.0, *) {
            performBatchUpdates(closer, completion: completion)
        } else {
            beginUpdates()
            closer()
            endUpdates()
            completion?(true)
        }
    }
}


