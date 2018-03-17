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
    
    weak var delegate: XHChannelEditViewControllerDelegate?
    
    private var longPressCell: UICollectionViewCell?
    
    private var channels: [XHHomeChannel]?
    
    private var isUpdate: Bool = false
    
    private lazy var longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
    
    private lazy var collectionView: UICollectionView = {
       let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 50)/4, height: 44)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 44)
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let temp = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        temp.dataSource = self
        temp.delegate = self
        temp.register(XHHomeChannelNormalCell.self, forCellWithReuseIdentifier: "normal")
        temp.register(XHHomeChannelAddCell.self, forCellWithReuseIdentifier: "add")
        temp.register(XHHomeChannelHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        temp.theme_backgroundColor = ThemeColorPicker.white
        temp.bounces = false
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalTo(UIEdgeInsets(top: 45, left: 0, bottom: 0, right: 0))
        }
        queryData()
        longPress.minimumPressDuration = 0.5
        view.addGestureRecognizer(longPress)
    }
    
    private func queryData() {
        XHHomeChannel.queryAllChannels {[weak self] (channels) in
            self?.channels = channels
            self?.collectionView.reloadData()
        }
    }
    
    @objc private func handleLongPress() {
        switch longPress.state {
        case .began:
            let location = longPress.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: location),indexPath.section == 0 {
                longPressCell = collectionView.cellForItem(at: indexPath)
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
            if !XHChannelEditManager.shared.isEidting {
                longPressCell?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                NotificationCenter.default.post(name: .homeChannelDidEditable, object: true)
                XHChannelEditManager.shared.isEidting = true
            }
        case .changed:
            if longPressCell != nil {
                let location = longPress.location(in: collectionView)
                collectionView.updateInteractiveMovementTargetPosition(location)
            }
        case .ended:
            if longPressCell != nil {
                collectionView.endInteractiveMovement()
                longPressCell?.transform = .identity
                longPressCell = nil
            }
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.view == collectionView {
            return true
        }
        return false
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        if isUpdate {
            delegate?.channelEditController(self, didUpdate: addChannels)
        }
        let fliter = addChannels.filter{ $0.isSelected }
        if let channel = fliter.first,let index = addChannels.index(of: channel) {
            delegate?.channelEditController(self, didSelectChannelAt: index)
        }
        super.dismiss(animated: flag, completion: completion)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        XHChannelEditManager.shared.isEidting = false
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! XHHomeChannelHeaderView
        header.setEditable(indexPath.section == 0)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 0 && indexPath.item > 0
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let channel = addChannels[sourceIndexPath.item]
        addChannels.remove(at: sourceIndexPath.item)
        addChannels.insert(channel, at: destinationIndexPath.item)
        isUpdate = true
    }
}

extension XHChannelEditViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var destination: IndexPath
        if indexPath.section == 0 {
            if XHChannelEditManager.shared.isEidting {
                guard indexPath.item > 0 else { return }
                destination = IndexPath(item: 0, section: 1)
                channels?.insert(addChannels[indexPath.item], at: 0)
                addChannels.remove(at: indexPath.item)
                moveItem(at: indexPath, to: destination)
            } else {
                let channel = addChannels[indexPath.item]
                if !channel.isSelected {
                    addChannels.filter{ $0.isSelected }.first?.isSelected = false
                    channel.isSelected = true
                }
                dismiss(animated: true, completion: nil)
            }
        } else {
            destination = IndexPath(item: addChannels.count, section: 0)
            addChannels.append(channels![indexPath.item])
            channels?.remove(at: indexPath.item)
            moveItem(at: indexPath, to: destination)
        }
        
    }
    
    private func moveItem(at indexPath: IndexPath, to destination: IndexPath) {
        collectionView.performBatchUpdates({
            collectionView.moveItem(at: indexPath, to: destination)
        }) { [weak self](_) in
            self?.collectionView.reloadItems(at: [destination])
            self?.isUpdate = true
        }
    }
    
}

protocol XHChannelEditViewControllerDelegate: NSObjectProtocol {
    
    func channelEditController(_ controller: XHChannelEditViewController,didUpdate channels: [XHHomeChannel])
    
    func channelEditController(_ controller: XHChannelEditViewController,didSelectChannelAt index: Int)
    
}
