//
//  XHPickerView.swift
//  Headline
//
//  Created by Li on 2018/3/21.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

@objc protocol XHPickerViewDataSource: NSObjectProtocol {
    
    @objc optional func numberOfComponents(_ picker: XHPickerView) -> Int
    
    func picker(_ picker: XHPickerView, numberOfRowsInComponent component: Int) -> Int
    
    func picker(_ picker: XHPickerView, cellForRowAt indexPath: IndexPath) -> XHPickerViewCell
    
}

@objc protocol XHPickerViewDelegate: NSObjectProtocol {
    
    func picker(_ picker: XHPickerView,didSelectRowAt indexPath: IndexPath)
    
    @objc optional func picker(_ picker: XHPickerView,willSelectRowAt indexPath: IndexPath)
    
    @objc optional func picker(_ picker: XHPickerView,willDeselectRowAt indexPath: IndexPath)
    
    @objc optional func picker(_ picker: XHPickerView,didScrollIn component: Int)
    
}

class XHPickerView: UIView {
    
    weak var delegate: XHPickerViewDelegate?
    
    weak var dataSource: XHPickerViewDataSource?
    
    var contentInset: UIEdgeInsets = .zero
    
    private var customIndicatorView: UIView?
    
    private var _indicatorView: UIView = UIView()
    
    lazy var indicatorTintColor: UIColor = UIColor.gray
    
    private var layout: XHPickerViewLayout
    
    private var tableViews: [UITableView] = []
    
    init(frame: CGRect,layout: XHPickerViewLayout) {
        self.layout = layout
        super.init(frame: frame)
        addSubview(_indicatorView)
        layout.pickerView = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents() -> Int {
        if let count = dataSource?.numberOfComponents?(self) {
            return count
        }
        return 2
    }
    
    func setCustomIndicatorView(_ view: UIView) {
        guard layout.indicatorStyle == .custom else { return }
        let subviews = _indicatorView.subviews
        for view in subviews {
            view.removeFromSuperview()
        }
        _indicatorView.addSubview(view)
        customIndicatorView = view
        bringSubview(toFront: _indicatorView)
    }
    
    func reloadData() {
        registerIdentifiers.removeAll()
        currentRows.removeAll()
        _willDeselectedRows.removeAll()
        layout.reloadData()
        configureMainSubviews()
        configure_indicatorView()
    }
    
    private func configure_indicatorView() {
        let subviews = _indicatorView.subviews
        for view in subviews {
            view.removeFromSuperview()
        }
        _indicatorView.backgroundColor = UIColor.clear
        _indicatorView.translatesAutoresizingMaskIntoConstraints = false
        _indicatorView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        _indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        _indicatorView.heightAnchor.constraint(equalToConstant: layout.rowHeight).isActive = true
        switch layout.indicatorStyle {
        case .default:
            for index in 0 ..< 2 {
                let view = UIView()
                view.backgroundColor = indicatorTintColor
                _indicatorView.addSubview(view)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.leadingAnchor.constraint(equalTo: _indicatorView.leadingAnchor, constant: contentInset.left).isActive = true
                view.trailingAnchor.constraint(equalTo: _indicatorView.trailingAnchor, constant: contentInset.right).isActive = true
                view.heightAnchor.constraint(equalToConstant: 1).isActive = true
                if index == 0 {
                    view.topAnchor.constraint(equalTo: _indicatorView.topAnchor).isActive = true
                } else {
                    view.bottomAnchor.constraint(equalTo: _indicatorView.bottomAnchor).isActive = true
                }
            }
        case .break:
            var x = contentInset.left
            for index in 0 ..< numberOfComponents() {
                let width = layout.widthForComponent(index)
                for nextIndex in 0 ..< 2 {
                    let view = UIView()
                    view.backgroundColor = indicatorTintColor
                    _indicatorView.addSubview(view)
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.widthAnchor.constraint(equalToConstant: width).isActive = true
                    view.leadingAnchor.constraint(equalTo: _indicatorView.leadingAnchor, constant: x).isActive = true
                    view.heightAnchor.constraint(equalToConstant: 1).isActive = true
                    if nextIndex == 0 {
                        view.topAnchor.constraint(equalTo: _indicatorView.topAnchor).isActive = true
                    } else {
                        view.bottomAnchor.constraint(equalTo: _indicatorView.bottomAnchor).isActive = true
                    }
                }
                x += width + layout.componentSpacing
            }
        case .highlight:
            _indicatorView.backgroundColor = indicatorTintColor
        case .custom:
            if let view = customIndicatorView {
                _indicatorView.addSubview(view)
            }
        }
    }
    
    private func configureMainSubviews() {
        for view in tableViews {
            view.removeFromSuperview()
        }
        let count = numberOfComponents()
        var x: CGFloat = contentInset.left
        for index in 0 ..< count {
            let tableView = UITableView(frame: .zero, style: .plain)
            addSubview(tableView)
            let width = layout.widthForComponent(index)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: x).isActive = true
            tableView.widthAnchor.constraint(equalToConstant: width).isActive = true
            tableView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            x += layout.componentSpacing + width
            tableViews.append(tableView)
            tableView.rowHeight = layout.rowHeight
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.backgroundColor = UIColor.clear
            tableView.showsVerticalScrollIndicator = false
            tableView.tag = index
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for tableView in tableViews {
            tableView.contentInset = UIEdgeInsets(top: _indicatorView.frame.minY, left: 0, bottom: _indicatorView.frame.minY, right: 0)
            tableView.contentOffset = CGPoint(x: 0, y: -_indicatorView.frame.minY)
            var currentRow = 0
            if currentRows[tableView.tag] != nil {
                currentRow = currentRows[tableView.tag]!
            } else {
                currentRows[tableView.tag] = 0
            }
            selectRow(at: IndexPath(row: currentRow, section: tableView.tag), animated: false)
        }
    }
    
    private var reuseIdentifiers: [String: AnyClass?] = [:]
    
    private var registerIdentifiers: [String] = []
    
    private var currentRows: [Int: Int] = [:]
    
    private var _willDeselectedRows: [Int: Int] = [:]
    
    private func registerToSubviews(_ cellClass: AnyClass?,forCellReuseIdentifier reuseIdentifier: String) {
        for tableView in tableViews {
            tableView.register(cellClass, forCellReuseIdentifier: reuseIdentifier)
        }
        registerIdentifiers.append(reuseIdentifier)
    }
    
    func register(_ cellClass: AnyClass?,forCellReuseIdentifier reuseIdentifier: String) {
        reuseIdentifiers.updateValue(cellClass, forKey: reuseIdentifier)
    }
    
    func dequeueReusableCell(withIdentifier identifier: String, for indexPath: IndexPath) -> XHPickerViewCell {
        if !registerIdentifiers.contains(identifier) {
            registerToSubviews(reuseIdentifiers[identifier]!, forCellReuseIdentifier: identifier)
        }
        let cell = tableViews[indexPath.section].dequeueReusableCell(withIdentifier: identifier, for: IndexPath(row: indexPath.row, section: 0)) as! XHPickerViewCell
        return cell
    }
    
    func selectRow(at indexPath: IndexPath,animated: Bool) {
        let tableView = tableViews[indexPath.section]
        let selectedIndexPath = IndexPath(row: indexPath.row, section: 0)
        tableView.scrollToRow(at: selectedIndexPath, at: .top, animated: animated)
        if let willDeselectedRow = _willDeselectedRows[indexPath.section] {
            if willDeselectedRow != selectedIndexPath.row && animated {
                delegate?.picker?(self, willSelectRowAt: indexPath)
                delegate?.picker?(self, willDeselectRowAt: IndexPath(row: willDeselectedRow, section: tableView.tag))
            }
        } else  {
            delegate?.picker?(self, willSelectRowAt: indexPath)
            _willDeselectedRows[tableView.tag] = indexPath.row
        }
    }
    
    func reloadData(inComponent component: Int) {
        currentRows[component] = 0
        let tableView = tableViews[component]
        tableView.reloadData()
        selectRow(at: IndexPath(row: 0, section: tableView.tag), animated: false)
    }
    
    func cellForRow(at indexPath: IndexPath) -> XHPickerViewCell {
        let tableView = tableViews[indexPath.section]
        return tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as! XHPickerViewCell
    }
    
    func cellsIntersectWithIndicatorView(inComponent component: Int) -> [XHPickerViewCell: CGRect] {
        let tableView = tableViews[component]
        let cells = tableView.visibleCells
        var result: [XHPickerViewCell: CGRect] = [:]
        for cell in cells {
            let cellRect = cell.convert(cell.bounds, to: self)
            let intersectiveRect = cellRect.intersection(_indicatorView.frame)
            if !intersectiveRect.isEmpty {
                var y: CGFloat = 0
                if cellRect.minY < _indicatorView.frame.minY {
                    y = layout.rowHeight - intersectiveRect.height
                }
                result[cell as! XHPickerViewCell] = CGRect(origin: CGPoint(x: 0, y: y), size: intersectiveRect.size)
            }
        }
        return result
    }
}

extension XHPickerView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = dataSource?.picker(self, numberOfRowsInComponent: tableView.tag) {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataSource!.picker(self, cellForRowAt: IndexPath(row: indexPath.row, section: tableView.tag))
        return cell
    }
    
}

extension XHPickerView: UITableViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetOffset = targetContentOffset.pointee.y + scrollView.contentInset.top
        var targetRow = lround(Double(targetOffset / layout.rowHeight))
        if targetRow < 0 {
            targetRow = 0
        } else {
            targetContentOffset.pointee.y = CGFloat(targetRow) * layout.rowHeight - scrollView.contentInset.top
        }
        currentRows[scrollView.tag] = targetRow
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        delegate?.picker(self, didSelectRowAt: IndexPath(row: currentRows[scrollView.tag]!, section: scrollView.tag))
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.picker(self, didSelectRowAt: IndexPath(row: currentRows[scrollView.tag]!, section: scrollView.tag))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.picker?(self, didScrollIn: scrollView.tag)
        let targetOffset = scrollView.contentOffset.y + scrollView.contentInset.top
        var targetRow = lround(Double(targetOffset / layout.rowHeight))
        if targetRow < 0 {
            targetRow = 0
        } else {
            let rows = dataSource!.picker(self, numberOfRowsInComponent: scrollView.tag) - 1
            if targetRow > rows {
                targetRow = rows
            }
        }
        let willDeselectedRow = _willDeselectedRows[scrollView.tag] ?? 0
        guard targetRow != willDeselectedRow else { return }
        UIView.animate(withDuration: 0.25) {[weak self] in
            self?.delegate?.picker?(self!, willSelectRowAt: IndexPath(row: targetRow, section: scrollView.tag))
            self?.delegate?.picker?(self!, willDeselectRowAt: IndexPath(row: willDeselectedRow, section: scrollView.tag))
        }
        _willDeselectedRows[scrollView.tag] = targetRow
    }
    
}


enum XHPickerViewIndicatorStyle {
    case `default`,`break`,highlight,custom
}

class XHPickerViewLayout: NSObject {
    
    var indicatorStyle: XHPickerViewIndicatorStyle = .default
    
    var rowHeight: CGFloat = 44
    
    var componentSpacing: CGFloat = 10
    
    var componentWidth: CGFloat = 0
    
    weak var pickerView: XHPickerView?
    
    fileprivate func reloadData() {
        _componentWidths.removeAll()
        let count = pickerView!.numberOfComponents()
        for _ in 0 ..< count {
            _componentWidths.append(nil)
        }
    }
    
    private lazy var _componentWidths: [CGFloat?] = []
    
    private weak var _delegate: XHPickerViewDelegateLayout? {
        if let delegate = pickerView?.delegate,delegate.conforms(to: XHPickerViewDelegateLayout.self) {
            return delegate as? XHPickerViewDelegateLayout
        }
        return nil
    }
    
    fileprivate func widthForComponent(_ component: Int) -> CGFloat {
        if let width = _componentWidths[component] {
            return width
        }
        if let width = _delegate?.picker?(pickerView!, layout: self, widthForRowInComponent: component) {
            _componentWidths[component] = width
            return width
        }
        if componentWidth == 0 {
            let width = UIScreen.main.bounds.width - pickerView!.contentInset.left - pickerView!.contentInset.right - CGFloat(_componentWidths.count - 1) * componentSpacing
            componentWidth = width / CGFloat(_componentWidths.count)
        }
        return componentWidth
    }
}

@objc protocol XHPickerViewDelegateLayout: NSObjectProtocol {
    
    @objc optional func picker(_ picker: XHPickerView,layout: XHPickerViewLayout,widthForRowInComponent component: Int) -> CGFloat
    
}

