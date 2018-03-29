//
//  XHPhotoViewerController.swift
//  Headline
//
//  Created by Li on 2018/3/27.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit



class XHPhotoViewerController: UIViewController {
    
    private var photos: [XHPhoto] = []
    
    private var currentIndex: Int = 0
    
    private var viewerType: XHPhotoViewerType = .single
    
    func setPhotosForMutableType(_ photos: [XHPhoto],at index: Int) {
        viewerType = .mutable
        self.photos.append(contentsOf: photos)
        self.currentIndex = index
    }
    
    func setPhotoForSingleType(_ photo: XHPhoto) {
        self.photos.append(photo)
    }
    
    private var singleIndex = 0
    
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = UIScreen.main.bounds.size
        let temp = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
//        temp.delegate = self
        temp.dataSource = self
        temp.bounces = false
        temp.isPagingEnabled = true
        temp.register(XHPhotoViewerCell.self, forCellWithReuseIdentifier: "cell")
        if #available(iOS 11.0, *) {
            temp.contentInsetAdjustmentBehavior = .never
        }
        
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        if #available(iOS 11.0, *) {} else {
            automaticallyAdjustsScrollViewInsets = false
        }
        switch viewerType {
        case .mutable:
            view.addSubview(collectionView)
        case .single:
            let scrollView = XHPhotoViewerScrollView()
            view.addSubview(scrollView)
            singleIndex = scrollView.setPhoto(photos.first!)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewerType == .mutable && collectionView.contentSize != .zero {
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        if viewerType == .single {
            let photo = photos.first!
            photo.closeClosure(for: photo.originalSize, at: singleIndex)
        }
    }

}

extension XHPhotoViewerController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! XHPhotoViewerCell
        cell.setPhoto(photos[indexPath.row])
        return cell
    }
    
}

private class XHPhotoViewerScrollView: UIScrollView {
    
    let imageView = UIImageView()
    
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        addSubview(imageView)
        contentSize = bounds.size
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never
        }
        imageView.contentMode = .scaleAspectFit
        delegate = self
        maximumZoomScale = 2.0
        minimumZoomScale = 1.0
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
        imageView.isUserInteractionEnabled = true
    }
    
    @objc private func handleDoubleTap() {
        if zoomScale == minimumZoomScale {
            zoomScale = maximumZoomScale
        } else {
            zoomScale = minimumZoomScale
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.center = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
    }
    
    @discardableResult func setPhoto(_ photo: XHPhoto) -> Int {
        let width = UIScreen.main.bounds.width
        let height = photo.originalSize.height / photo.originalSize.width * width
        imageView.bounds = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        let index = photo.fetchOriginalPhoto { [weak self](image) in
            self?.imageView.image = image
        }
        contentSize = CGSize(width: frame.width, height: height)
        if height > frame.height {
            contentInset = .zero
        } else {
            contentInset = UIEdgeInsets(top: (frame.height - height) / 2, left: 0, bottom: (frame.height - height) / 2, right: 0)
        }
        return index
    }
    
}

extension XHPhotoViewerScrollView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        var height = imageView.bounds.height * scrollView.zoomScale
        if height > frame.height {
            height = frame.height
        }
        contentInset = UIEdgeInsets(top: (frame.height - height) / 2, left: 0, bottom: (frame.height - height) / 2, right: 0)
    }
    
}

private class XHPhotoViewerCell: UICollectionViewCell {
    
    private var scrollView = XHPhotoViewerScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(scrollView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var _photo: XHPhoto?
    
    private var index: Int = 0
    
    func setPhoto(_ photo: XHPhoto) {
        _photo = photo
        index = scrollView.setPhoto(photo)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollView.zoomScale = scrollView.minimumZoomScale
        _photo?.closeClosure(for: _photo!.originalSize, at: index)
    }
    
    deinit {
        _photo?.closeClosure(for: _photo!.originalSize, at: index)
    }
    
}
