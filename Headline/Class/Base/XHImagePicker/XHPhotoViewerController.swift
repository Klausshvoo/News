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
    
    private var selectedPhotos: [XHPhoto] {
        return photos.filter({ $0.isSelected })
    }
    
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
        temp.delegate = self
        temp.dataSource = self
        temp.bounces = false
        temp.isPagingEnabled = true
        temp.register(XHPhotoViewerCell.self, forCellWithReuseIdentifier: "cell")
        if #available(iOS 11.0, *) {
            temp.contentInsetAdjustmentBehavior = .never
        }
        return temp
    }()
    
    private lazy var mutableBar: XHPhotoMutableSelectBar = {
        let temp = XHPhotoMutableSelectBar()
        temp.addTargetForSend(self, action: #selector(shouldSendSelectedImages))
        temp.setSelectedCount(selectedPhotos.count)
        temp.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return temp
    }()
    
    lazy var clipView: XHPhotoClipView = {
        let temp = XHPhotoClipView(frame: UIScreen.main.bounds)
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
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_unselected"), style: .plain, target: self, action: #selector(shouldSelectCurrentPhoto(_:)))
            view.addSubview(collectionView)
            view.addSubview(mutableBar)
            mutableBar.translatesAutoresizingMaskIntoConstraints = false
            mutableBar.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
            mutableBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
            mutableBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            mutableBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            changeImageForRightItem()
        case .single:
            view.addSubview(clipView)
            singleIndex = clipView.scrollView.setPhoto(photos.first!)
            let item = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(shouldSendSelectedImages))
            item.setTitleTextAttributes([.foregroundColor: UIColor.green], for: .normal)
            navigationItem.rightBarButtonItem = item
        }
        configureTap()
    }
    
    private func configureTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewerType == .mutable && collectionView.contentSize != .zero {
            collectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
        }
    }
    
    @objc private func shouldSendSelectedImages() {
        switch viewerType {
        case .mutable:
            if let navigtion = navigationController as? XHImagePickerController {
                navigtion._delegate?.imagePickerController?(navigtion, didFinishPickingPhotos: selectedPhotos)
            }
        case .single:
            if let navigtion = navigationController as? XHImagePickerController {
                navigtion._delegate?.imagePickerController?(navigtion, didFinishPickingPhoto: photos.first!, editImage: clipView.clipImage())
            }
        }
        
    }
    
    @objc private func shouldSelectCurrentPhoto(_ sender: UIBarButtonItem) {
        let photo = photos[currentIndex]
        photo.isSelected = !photo.isSelected
        let colletion = navigationController?.viewControllers[1] as? XHPhotoCollectionViewController
        colletion?.reloadItemSelectState(at: currentIndex)
        mutableBar.setSelectedCount(selectedPhotos.count)
        changeImageForRightItem()
    }
    
    private func changeImageForRightItem() {
        let photo = photos[currentIndex]
        navigationItem.rightBarButtonItem?.image = UIImage(named: photo.isSelected ? "icon_elect" : "icon_unselected")
    }
    
    @objc private func handleTap() {
        navigationController?.isNavigationBarHidden = !navigationController!.isNavigationBarHidden
        mutableBar.isHidden = !mutableBar.isHidden
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

extension XHPhotoViewerController: UICollectionViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(collectionView.contentOffset.x/collectionView.bounds.width)
        changeImageForRightItem()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        scrollViewDidEndDecelerating(scrollView)
    }
    
}

extension XHPhotoViewerController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
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

class XHPhotoClipView: UIView {
    
    fileprivate let scrollView = XHPhotoClipScrollView()
    
    private let marginHorizontal: CGFloat = 15
    
    private lazy var marginVertical: CGFloat = {
        let width = frame.width - 2 * marginHorizontal
        return (frame.height - width) / 2
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        scrollView.frame = bounds
        scrollView.contentInset = UIEdgeInsets(top: marginVertical, left: marginHorizontal, bottom: marginVertical, right: marginHorizontal)
        scrollView.maxContentHeight = frame.height - 2 * marginVertical
        drawClipLayer(fromPoint: CGPoint(x: 0, y: marginVertical / 2), to: CGPoint(x: frame.width, y: marginVertical / 2), lineWidth: marginVertical)
        drawClipLayer(fromPoint: CGPoint(x: frame.width - marginHorizontal / 2, y: marginVertical), to: CGPoint(x: frame.width - marginHorizontal / 2, y: frame.height - marginVertical), lineWidth: marginHorizontal)
        drawClipLayer(fromPoint: CGPoint(x: frame.width, y: frame.height - marginVertical / 2), to: CGPoint(x: 0, y: frame.height - marginVertical / 2), lineWidth: marginVertical)
        drawClipLayer(fromPoint: CGPoint(x: marginHorizontal / 2, y: frame.height - marginVertical), to: CGPoint(x: marginHorizontal / 2, y: marginVertical), lineWidth: marginHorizontal)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: marginHorizontal - 1, y: marginVertical - 1))
        path.addLine(to: CGPoint(x: frame.width - marginHorizontal + 1, y: marginVertical - 1))
        path.addLine(to: CGPoint(x: frame.width - marginHorizontal + 1, y: frame.height - marginVertical + 1))
        path.addLine(to: CGPoint(x: marginHorizontal - 1, y: frame.height - marginVertical + 1))
        path.close()
        let pathLayer = CAShapeLayer()
        pathLayer.path = path.cgPath
        pathLayer.frame = bounds
        pathLayer.lineWidth = 2
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.white.cgColor
        self.layer.addSublayer(pathLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawClipLayer(fromPoint: CGPoint,to endPoint: CGPoint,lineWidth: CGFloat) {
        let path = UIBezierPath()
        path.move(to: fromPoint)
        path.addLine(to: endPoint)
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.frame = bounds
        layer.lineWidth = lineWidth
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        self.layer.addSublayer(layer)
    }
    
    var clipRect: CGRect {
        let scale = UIScreen.main.scale / scrollView.zoomScale
        let width = (frame.width - 2 * marginHorizontal)
        let imageRect = scrollView.imageView.convert(scrollView.imageView.bounds, to: self)
        let clipRect = CGRect(x: marginHorizontal, y: marginVertical, width: width, height: width)
        let rect = imageRect.intersection(clipRect)
        let x = (scrollView.contentOffset.x + scrollView.contentInset.left) * scale
        let y = (scrollView.contentOffset.y + scrollView.contentInset.top) * scale
        return CGRect(x: x, y: y, width: rect.width * scale, height: rect.height * scale)
    }
    
    func clipImage() -> UIImage? {
        let image = scrollView.imageView.image
        return image?.clipRect(clipRect)
    }
    
}

private class XHPhotoClipScrollView: XHPhotoViewerScrollView {
    
    fileprivate var maxContentHeight: CGFloat = 0
    
    override func scrollViewDidZoom(_ scrollView: UIScrollView) {
        guard imageView.bounds.height < maxContentHeight else { return }
        let height = imageView.bounds.height * scrollView.zoomScale
        var top: CGFloat = (frame.height - maxContentHeight) / 2
        if height < maxContentHeight {
            top += (maxContentHeight - height) / 2
        }
        contentInset = UIEdgeInsets(top: top, left: contentInset.left, bottom: top, right: contentInset.right)
    }
    
    override func setPhoto(_ photo: XHPhoto) -> Int {
        let width = frame.width - contentInset.left - contentInset.right
        let height = photo.originalSize.height / photo.originalSize.width * width
        imageView.bounds = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        let index = photo.fetchOriginalPhoto { [weak self](image) in
            self?.imageView.image = image
        }
        contentSize = CGSize(width: width, height: height)
        if height < maxContentHeight  {
            let margin = (maxContentHeight - height) / 2
            contentInset = UIEdgeInsets(top: contentInset.top + margin, left: contentInset.left, bottom: contentInset.bottom + margin, right: contentInset.right)
        }
        return index
    }
    
}

extension UIImage {
    
    /// 图像的size必须包含该rect
    func clipRect(_ rect: CGRect) -> UIImage {
        let cgimage = cgImage!.cropping(to: rect)!
        let bounds = CGRect(origin: CGPoint.zero, size: rect.size)
        UIGraphicsBeginImageContext(bounds.size)
        let context = UIGraphicsGetCurrentContext()
        context?.draw(cgimage, in: bounds)
        let image = UIImage(cgImage: cgimage)
        UIGraphicsEndImageContext()
        return image
    }
    
}
