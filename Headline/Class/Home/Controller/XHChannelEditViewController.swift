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
    
    var addChannels: [XHHomeChannel]!
    
    private var channels: [XHHomeChannel]?
    
    private lazy var collectionView: UICollectionView = {
       let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 50)/4, height: 44)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let temp = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        temp.dataSource = self
        temp.delegate = self
        temp.register(XHHomeChannelNormalCell.self, forCellWithReuseIdentifier: "normal")
        temp.register(XHHomeChannelAddCell.self, forCellWithReuseIdentifier: "add")
        temp.theme_backgroundColor = ThemeColorPicker.white
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalTo(UIEdgeInsets(top: 45, left: 0, bottom: 0, right: 0))
        }
        queryData()
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        view.addGestureRecognizer(longPress)
    }
    
    private func queryData() {
        XHHomeChannel.queryAllChannels {[weak self] (channels) in
            self?.channels = channels
            self?.collectionView.reloadData()
        }
    }
    
    @objc fileprivate func handleLongPress() {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension XHChannelEditViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let channels = section == 0 ? addChannels : self.channels
        return channels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = indexPath.section == 0 ? "normal" : "add"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! XHHomeChannelCell
        let channels = indexPath.section == 0 ? addChannels : self.channels
        cell.setChannel(channels![indexPath.item])
        return cell
        
    }
    
}

extension XHChannelEditViewController: UICollectionViewDelegate {
    
}
