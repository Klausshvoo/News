//
//  XHChannelEditViewController.swift
//  Headline
//
//  Created by Li on 2018/3/16.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import SwiftTheme

class XHChannelEditViewController: XHBottomPersentViewController {
    
    private var channels: [XHHomeChannel]?
    
    private lazy var collectionView: UICollectionView = {
       let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 80, height: 44)
        let temp = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        temp.dataSource = self
        temp.delegate = self
        temp.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        temp.theme_backgroundColor = ThemeColorPicker.white
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalTo(UIEdgeInsets(top: 45, left: 0, bottom: 0, right: 0))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension XHChannelEditViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
}

extension XHChannelEditViewController: UICollectionViewDelegate {
    
}
