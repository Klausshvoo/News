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
    
    private let spaceMargin: CGFloat = 5
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = spaceMargin
        flowLayout.minimumInteritemSpacing = spaceMargin
        let width = (UIScreen.main.bounds.width - 5 * spaceMargin) / 4
        flowLayout.itemSize = CGSize(width: width, height: width)
        let temp = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        temp.backgroundColor = UIColor.white
//        temp.delegate = self
        temp.dataSource = self
        temp.bounces = false
        temp.contentInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        temp.register(XHPhotoThumbCell.self, forCellWithReuseIdentifier: "cell")
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if collectionView.contentSize != .zero {
            collectionView.scrollToItem(at: IndexPath(item: photoAblum.photos.count - 1, section: 0), at: .bottom, animated: false)
        }
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
    
    private var _photo: XHPhoto?
    
    func setPhoto(_ photo: XHPhoto) {
        _photo = photo
        _photo?.fetchPhoto(in: imageView.bounds.size, completion: { [weak self](image) in
            self?.imageView.image = image
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _photo?.closeClosure(for: imageView.bounds.size)
    }
}
