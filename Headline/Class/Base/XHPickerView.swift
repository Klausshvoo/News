//
//  XHPickerView.swift
//  Headline
//
//  Created by Li on 2018/3/21.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

@objc protocol XHPickerViewDataSource: NSObjectProtocol {
    
    func numberOfComponents(_ picker: XHPickerView) -> Int
    
    func picker(_ picker: XHPickerView, numberOfRowsInComponent component: Int) -> Int
    
    func picker(_ picker: XHPickerView, cellForRowAt indexPath: IndexPath) -> XHPickerViewCell
    
}

@objc protocol xhPickerViewDelegate: NSObjectProtocol {
    
    func picker(_ picker: XHPickerView,didSelectRowAt indexPath: IndexPath)
    
}

class XHPickerView: UIView {
    
    private var _indicatorView: UIView = UIView()
    
    var indicatorTintColor: UIColor?
    
    private var layout: XHPickerViewLayout
    
    init(layout: XHPickerViewLayout) {
        self.layout = layout
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure_indicatorView() {
        addSubview(_indicatorView)
        _indicatorView.translatesAutoresizingMaskIntoConstraints = false
        _indicatorView.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor).isActive = true
        _indicatorView.centerXAnchor.constraint(equalTo: layoutMarginsGuide.centerXAnchor).isActive = true
        _indicatorView.centerYAnchor.constraint(equalTo: layoutMarginsGuide.centerYAnchor).isActive = true
    }
    
}
