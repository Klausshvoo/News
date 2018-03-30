//
//  XHPhotoCollectionViewController.swift
//  Headline
//
//  Created by Li on 2018/3/27.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHPhotoCollectionViewController: UIViewController {
    
    var photoAblum: XHPhotoAlbum! {
        didSet {
            title = photoAblum.localizedTitle
        }
    }
    
    private var viewerType: XHPhotoViewerType {
        let navigation = navigationController as! XHImagePickerController
        return navigation.viewerType!
    }
    
    private let spaceMargin: CGFloat = 5
    
    private var selectedPhotos: [XHPhoto] {
        return photoAblum.photos.filter({ $0.isSelected })
    }
    
    private var beginScrolled: Bool = false
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = spaceMargin
        flowLayout.minimumInteritemSpacing = spaceMargin
        let width = (UIScreen.main.bounds.width - 5 * spaceMargin) / 4
        flowLayout.itemSize = CGSize(width: width, height: width)
        let temp = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        temp.backgroundColor = UIColor.white
        temp.delegate = self
        temp.dataSource = self
        temp.bounces = false
        var inset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        switch viewerType {
        case .mutable:
            temp.register(XHPhotoThumbMutableCell.self, forCellWithReuseIdentifier: "cell")
            inset.bottom = 40
            view.addSubview(mutableBar)
            mutableBar.translatesAutoresizingMaskIntoConstraints = false
            mutableBar.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
            mutableBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
            mutableBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            mutableBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        case .single:
            temp.register(XHPhotoThumbCell.self, forCellWithReuseIdentifier: "cell")
        }
        temp.contentInset = inset
        return temp
    }()
    
    private lazy var mutableBar: XHPhotoMutableSelectBar = {
        let temp = XHPhotoMutableSelectBar()
        temp.addTargetForSend(self, action: #selector(shouldSendSelectedImages))
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.insertSubview(collectionView, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if collectionView.contentSize != .zero && !beginScrolled {
            beginScrolled = true
            collectionView.scrollToItem(at: IndexPath(item: photoAblum.photos.count - 1, section: 0), at: .bottom, animated: false)
        }
    }
    
    @objc private func shouldSendSelectedImages() {
        if let navigtion = navigationController as? XHImagePickerController {
            navigtion._delegate?.imagePickerController?(navigtion, didFinishPickingPhotos: selectedPhotos)
        }
    }
    
    internal func reloadItemSelectState(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.performBatchUpdates({[weak self] in
            self?.collectionView.reloadItems(at: [indexPath])
        }, completion: nil)
        mutableBar.setSelectedCount(selectedPhotos.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension XHPhotoCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAblum.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! XHPhotoThumbCell
        cell.setPhoto(photoAblum.photos[indexPath.row])
        return cell
    }
    
}

extension XHPhotoCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewerController = XHPhotoViewerController()
        switch viewerType {
        case .mutable:
            viewerController.setPhotosForMutableType(photoAblum.photos, at: indexPath.row)
        case .single:
            viewerController.setPhotoForSingleType(photoAblum.photos[indexPath.row])
        }
        navigationController?.pushViewController(viewerController, animated: true)
    }
    
    fileprivate func photoSelectStateChanged(in cell: XHPhotoThumbMutableCell) {
        let index = collectionView.indexPath(for: cell)!.row
        let photo = photoAblum.photos[index]
        photo.isSelected = !photo.isSelected
        mutableBar.setSelectedCount(selectedPhotos.count)
    }
    
}

private class XHPhotoThumbCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFill
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var _photo: XHPhoto?
    
    private var index: Int = 0
    
    func setPhoto(_ photo: XHPhoto) {
        _photo = photo
        index = photo.fetchPhoto(in: imageView.bounds.size, completion: { [weak self](image) in
            self?.imageView.image = image
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _photo?.closeClosure(for: imageView.bounds.size, at: index)
    }
    
    deinit {
        _photo?.closeClosure(for: imageView.bounds.size, at: index)
    }
}

private class XHPhotoThumbMutableCell: XHPhotoThumbCell {
    
    private let selectedButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(selectedButton)
        selectedButton.translatesAutoresizingMaskIntoConstraints = false
        selectedButton.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -1).isActive = true
        selectedButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1).isActive = true
        selectedButton.setImage(UIImage(named: "icon_unselected"), for: .normal)
        selectedButton.setImage(UIImage(named: "icon_elect"), for: .selected)
        selectedButton.addTarget(self, action: #selector(updateSelectState), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func updateSelectState() {
        selectedButton.isSelected = !selectedButton.isSelected
        let controller = self.controller as? XHPhotoCollectionViewController
        controller?.photoSelectStateChanged(in: self)
    }
    
    override func setPhoto(_ photo: XHPhoto) {
        super.setPhoto(photo)
        selectedButton.isSelected = photo.isSelected
    }
    
}

class XHPhotoMutableSelectBar: UIView {
    
    let sendButton = UIButton(type: .custom)
    
    convenience init() {
        self.init(frame: .zero)
        backgroundColor = UIColor.black
        addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        sendButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        sendButton.setTitle("确定", for: .disabled)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        sendButton.backgroundColor = UIColor.green
        sendButton.isEnabled = false
        sendButton.layer.cornerRadius = 5
        sendButton.layer.masksToBounds = true
    }
    
    func setSelectedCount(_ count: Int) {
        sendButton.isEnabled = count > 0
        if sendButton.isEnabled {
            sendButton.setTitle("确定(\(count))", for: .normal)
        }
    }
    
    func addTargetForSend(_ target: Any,action: Selector) {
        sendButton.addTarget(target, action: action, for: .touchUpInside)
    }
}
