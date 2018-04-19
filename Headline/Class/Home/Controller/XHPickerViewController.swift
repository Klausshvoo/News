//
//  XHPickerViewController.swift
//  Headline
//
//  Created by Li on 2018/4/19.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHPickerViewController: UIViewController {
    
    private lazy var pickerView: XHPickerView = {
       let layout = XHPickerViewLayout()
        layout.indicatorStyle = .highlight
        let temp = XHPickerView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 224, width: UIScreen.main.bounds.width, height: 224), layout: layout)
        temp.register(XHPickerViewCell.self, forCellReuseIdentifier: "cell")
        temp.dataSource = self
        temp.delegate = self
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 0.7)
        view.addSubview(pickerView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension XHPickerViewController: XHPickerViewDataSource {
    
    func numberOfComponents(_ picker: XHPickerView) -> Int {
        return 2
    }
    
    func picker(_ picker: XHPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 12
    }
    
    func picker(_ picker: XHPickerView, cellForRowAt indexPath: IndexPath) -> XHPickerViewCell {
        let cell = picker.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.label.text = "\(indexPath.row)"
        return cell
    }
    
}

extension XHPickerViewController: XHPickerViewDelegate {
    
    func picker(_ picker: XHPickerView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func picker(_ picker: XHPickerView, didScrollIn component: Int) {
        let cells = picker.cellsIntersectWithIndicatorView(inComponent: component)
        for (cell,rect) in cells {
            cell.label.selectedRect = rect
        }
    }
    
//    func picker(_ picker: XHPickerView, willSelectRowAt indexPath: IndexPath) {
//        let cell = picker.cellForRow(at: indexPath)
//        cell.contentView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
//    }
//    
//    func picker(_ picker: XHPickerView, willDeselectRowAt indexPath: IndexPath) {
//        let cell = picker.cellForRow(at: indexPath)
//        cell.contentView.transform = CGAffineTransform.identity
//    }

}
