//
//  XHSearchPromptsController.swift
//  Headline
//
//  Created by Li on 2018/4/2.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHSearchPromptsController: UIViewController {
    
//    lazy var dataArr: [[String]] = {
//        return [["南山植物园","一只酸奶牛","两江国际影视城","蛋糕","地铁","鲱鱼","肯德基"],["南山植物园","蛋糕","地铁","鲱鱼","肯德基","一只酸奶牛","两江国际影视城"]]
//    }()
    
    lazy var dataArr: [String] = ["两江国际影视城南山植南山植物园","两江国际影视城南山植南山植物园"]
    
    var text: String = ""
    
    private lazy var textField: UITextField = {
        let temp = UITextField()
        temp.placeholder = "请输入"
        temp.font = UIFont.systemFont(ofSize: 13)
        temp.delegate = self
        temp.returnKeyType = .done
        temp.addTarget(self, action: #selector(textFieldTextDidChange), for: .editingChanged)
        return temp
    }()
    
    private var textFieldWidth: CGFloat = 80
    
    let widthManager = XHSearchPromptWidthCacheManager()
    
    lazy var collectionView: UICollectionView = {
        let layout = XHFixedSpaceLayout()
        layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        let temp = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        temp.dataSource = self
        temp.delegate = self
        temp.register(XHFixedSpaceCell.self, forCellWithReuseIdentifier: "cell")
        temp.register(XHFixedSpaceTextFieldCell.self, forCellWithReuseIdentifier: "text")
        temp.backgroundColor = UIColor.white
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let button = UIButton(type: .system)
        button.setTitle("取消", for: .normal)
        button.frame = CGRect(x: 0, y: 20, width: 60, height: 44)
        view.addSubview(button)
        button.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
        view.addSubview(button)
        view.addSubview(collectionView)
        collectionView.addSubview(textField)
        textField.frame = CGRect(x: 15, y: 15, width: textFieldWidth, height: 30)
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension XHSearchPromptsController: UICollectionViewDataSource {
    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return dataArr.count
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return dataArr[section].count
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == dataArr.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "text", for: indexPath) as! XHFixedSpaceTextFieldCell
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! XHFixedSpaceCell
//        cell.setPrompt(dataArr[indexPath.section][indexPath.item])
        cell.setPrompt(dataArr[indexPath.item])
        return cell
    }
    
}

extension XHSearchPromptsController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            if !textField.text!.isEmpty {
                
            }
            return true
        }
        if string == "," || string == "，" {
            if !textField.text!.isEmpty {
                
                textField.text = ""
            }
            return false
        }
        if textField.text!.count > 10 {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if !textField.text!.isEmpty {
            
            textField.text = ""
            return true
        }
        return false
    }
    
    @objc private func textFieldTextDidChange() {
        var width = textField.text!.size(withAttributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 13)]).width + 20
        if width < 80 {
            width = 80
        }
        if width != textFieldWidth {
            textFieldWidth = width
            collectionView.performBatchUpdates({[weak self] in
                self?.collectionView.reloadItems(at: [IndexPath(item: dataArr.count, section: 0)])
            }, completion: { [weak self](_) in
                self?.changeTextFiledFrame()
            })
        }
    }
    
    private func changeTextFiledFrame() {
        if let cell = collectionView.cellForItem(at: IndexPath(item: dataArr.count, section: 0)) {
            textField.frame = cell.frame
        }
    }
    
}

extension XHSearchPromptsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let prompt = dataArr[indexPath.section][indexPath.item]
        if indexPath.item == dataArr.count {
            return CGSize(width: textFieldWidth, height: 30)
        }
        let prompt = dataArr[indexPath.item]
        let width = widthManager.width(forPrompt: prompt)
        return CGSize(width: width, height: 30)
    }
    
}

class XHSearchPromptWidthCacheManager: NSObject {
    
    private var cache: [String: CGFloat] = [:]
    
    var font: UIFont = UIFont.systemFont(ofSize: 13)
    
    func width(forPrompt prompt: String) -> CGFloat {
        if let width = cache[prompt] {
            return width
        }
        let width = prompt.size(withAttributes: [NSAttributedStringKey.font: font]).width + 10
        return width
    }
    
}

class XHFixedSpaceCell: UICollectionViewCell {
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 13)
        layer.borderWidth = 1.0
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = UIColor.gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPrompt(_ prompt: String) {
        label.text = prompt
    }
}

class XHFixedSpaceTextFieldCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1.0
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = UIColor.gray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

