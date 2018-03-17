//
//  XHPageTitleView.swift
//  Headline
//
//  Created by Li on 2018/3/12.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SnapKit
import SwiftTheme

protocol XHPageTitleViewDataSource: NSObjectProtocol {
    
    func numberOfItems(_ pageTitleView: XHPageTitleView) -> Int
    
    func pageTitleView(_ pageTitleView: XHPageTitleView, titleForItemAt index: Int) -> String
    
}

protocol XHPageTitleViewDelegate: NSObjectProtocol {
    
    func pageTitleView(_ pageTitleView: XHPageTitleView, didSelectItemAt index: Int)
    
}

class XHPageTitleView: UIView {
    
    weak var dataSource: XHPageTitleViewDataSource?
    
    weak var delegate: XHPageTitleViewDelegate?
    
    var itemInsets: CGFloat = 10
    
    var indicatorFont: UIFont = UIFont.systemFont(ofSize: 18)
    
    var tailView: UIView?
    
    private let scrollView = UIScrollView()
    
    fileprivate var buttons: [UIButton] = []
    
    private var currentItem: UIButton?
    
    private let minScale: CGFloat = 0.8
    
    convenience init() {
        self.init(frame: .zero)
        theme_backgroundColor = .background
        addSubview(scrollView)
        scrollView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 2
        layer.shadowOffset = CGSize(width: 0, height: 1)
    }
    
    func reloadData() {
        scrollView.contentSize = .zero
        currentItem = nil
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons.removeAll()
        tailView?.removeFromSuperview()
        guard let count = dataSource?.numberOfItems(self) else { return }
        var lastItem: UIView = scrollView
        for index in 0 ..< count {
            let title = dataSource!.pageTitleView(self, titleForItemAt: index)
            let button = UIButton(type: .custom)
            scrollView.addSubview(button)
            button.setTitle(title, for: .normal)
            button.titleLabel?.font = indicatorFont
            buttons.append(button)
            button.tag = index
            button.theme_setTitleColor(ThemeColorPicker.black, forState: .normal)
            button.snp.makeConstraints{
                $0.top.equalTo(lastItem)
                $0.bottom.equalTo(lastItem)
                $0.width.greaterThanOrEqualTo(40)
                if lastItem == scrollView {
                    $0.left.equalTo(lastItem).offset(itemInsets)
                    $0.height.equalTo(lastItem)
                } else {
                    $0.left.equalTo(lastItem.snp.right).offset(itemInsets)
                }
            }
            button.addTarget(self, action: #selector(didSelectItem(_:)), for: .touchUpInside)
            button.titleLabel?.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            button.titleLabel?.textAlignment = .center
            lastItem = button
        }
        var rightInsets = itemInsets
        if let tailView = tailView {
            addSubview(tailView)
            tailView.snp.makeConstraints{
                $0.right.equalToSuperview()
                $0.width.equalTo(tailView.bounds.width)
                $0.height.equalTo(tailView.bounds.height)
                $0.centerY.equalTo(self)
            }
            rightInsets += tailView.bounds.width
        }
        lastItem.snp.makeConstraints{
            $0.right.equalTo(scrollView).offset(-rightInsets)
        }
        didSelectItem(buttons[0])
    }
    public func didSelectItem(at index: Int) {
        didSelectItem(buttons[index])
    }
    
    @objc private func didSelectItem(_ sender: UIButton) {
        responseSelectItem(sender)
        delegate?.pageTitleView(self, didSelectItemAt: sender.tag)
    }
    
    private func responseSelectItem(_ sender: UIButton) {
        guard !sender.isSelected else {
            return
        }
        currentItem?.isSelected = false
        currentItem?.theme_setTitleColor(ThemeColorPicker.black, forState: .normal)
        currentItem?.titleLabel?.transform = CGAffineTransform(scaleX: minScale, y: minScale)
        sender.isSelected = true
        sender.theme_setTitleColor(ThemeColorPicker.red, forState: .normal)
        sender.titleLabel?.transform = CGAffineTransform.identity
        currentItem = sender
        if sender.frame == .zero {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: {[weak self] in
                self?.scrollTo(sender)
            })
        } else {
            scrollTo(sender)
        }
    }
    
    private func scrollTo(_ sender: UIButton) {
        var point: CGPoint
        if sender.frame.midX < bounds.width/2 {
            point = .zero
        } else {
            if scrollView.contentSize.width - sender.frame.midX < bounds.width/2 {
                point = CGPoint(x: scrollView.contentSize.width - frame.width, y: 0)
            } else {
                point = CGPoint(x: sender.frame.midX - bounds.width/2, y: 0)
            }
        }
        scrollView.setContentOffset(point, animated: true)
    }
    
    public func setProgress(_ progress: Float) {
        guard let currentItem = currentItem else { return }
        var nextIndex = currentItem.tag
        if progress > 0 {
            nextIndex += 1
        } else {
            nextIndex -= 1
        }
        guard nextIndex < buttons.count && nextIndex >= 0 else { return }
        let nextItem = buttons[nextIndex]
        let absProgress = CGFloat(fabsf(progress))
        if absProgress >= 1 {
            responseSelectItem(nextItem)
            return
        }
        let scale = (1 - minScale) * absProgress
        currentItem.titleLabel?.transform = CGAffineTransform(scaleX: 1 - scale, y: 1 - scale)
        setProgress(1 - absProgress, for: currentItem)
        nextItem.titleLabel?.transform = CGAffineTransform(scaleX: minScale + scale, y: minScale + scale)
        setProgress(absProgress, for: nextItem)
    }
    
    private func setProgress(_ progress: CGFloat,for item: UIButton) {
        if Theme.shared.style == .day {
            let left = UIColor(hex: 0x333333)
            let right = UIColor(hex: 0xc44943)
            let currentColor = UIColor(begin: left, end: right, progress: progress)
            item.setTitleColor(currentColor, for: .normal)
        } else {
            let left = UIColor(hex: 0x6a6a6a)
            let right = UIColor(hex: 0x211d21)
            let currentColor = UIColor(begin: left, end: right, progress: progress)
            item.setTitleColor(currentColor, for: .normal)
        }
    }
    
}

extension UIColor {
    
    private func RGB() -> (CGFloat,CGFloat,CGFloat,CGFloat) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red,green,blue,alpha)
    }
    
    convenience init(begin: UIColor,end: UIColor,progress: CGFloat) {
        let beginRGB = begin.RGB()
        let endRGB = end.RGB()
        let resultR = (endRGB.0 - beginRGB.0) * progress + beginRGB.0
        let resultG = (endRGB.1 - beginRGB.1) * progress + beginRGB.1
        let resultB = (endRGB.2 - beginRGB.2) * progress + beginRGB.2
        let resultA = (endRGB.3 - beginRGB.3) * progress + beginRGB.3
        self.init(red: resultR, green: resultG, blue: resultB, alpha: resultA)
    }
}

extension XHPageTitleView: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        guard index < buttons.count else { return }
        didSelectItem(buttons[index])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let currentItem = currentItem else { return }
        let offset = Float(scrollView.contentOffset.x / scrollView.bounds.width)
        let progress = offset - Float(currentItem.tag)
        setProgress(progress)
    }
    
}
