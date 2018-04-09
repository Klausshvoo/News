//
//  XHImagePickerController.swift
//  Headline
//
//  Created by Li on 2018/3/27.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

enum XHImagePickerControllerSourceType {
    
    case photoLibrary,camera

}

enum XHPhotoViewerType {
    
    case mutable,single
    
}

struct XHImagePickerMediaType: OptionSet {
    
    public let rawValue: UInt
    
    static let video = XHImagePickerMediaType(rawValue: 0)
    
    static let photo = XHImagePickerMediaType(rawValue: 1)
    
}


@objc protocol XHImagePickerControllerDelegate: NSObjectProtocol {
    
    @objc optional func imagePickerController(_ picker: XHImagePickerController, didFinishPickingPhotos photos: [XHPhoto])
    
    func imagePickerControllerDidCancel(_ picker: XHImagePickerController)
    
    @objc optional func imagePickerController(_ picker: XHImagePickerController, didFinishPickingPhoto photo: XHPhoto,editImage: UIImage?)
    
    @objc optional func imagePickerController(_ picker: XHImagePickerController, didFinishTakingPhoto data: Data?)
    
}

class XHImagePickerController: UINavigationController {
    
    weak var _delegate: XHImagePickerControllerDelegate?
    
    private(set) var sourceType: XHImagePickerControllerSourceType
    
    private(set) var viewerType: XHPhotoViewerType
    
    private var _maxSelectedCount: Int = 0
    
    var mediaTypes: XHImagePickerMediaType = .photo
    
    var maxSelectedCount: Int {
        set {
            if viewerType == .mutable && sourceType == .photoLibrary {
                _maxSelectedCount = newValue
            }
        }
        get {
            return _maxSelectedCount
        }
    }
    
    init(sourceType: XHImagePickerControllerSourceType,for viewerType: XHPhotoViewerType = .single) {
        self.sourceType = sourceType
        self.viewerType = viewerType
        if viewerType == .single {
            _maxSelectedCount = 1
        }
        let item = UIBarButtonItem.appearance(whenContainedInInstancesOf: [XHImagePickerController.self])
        item.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 15),.foregroundColor: UIColor.white], for: .normal)
        super.init(nibName: nil, bundle: nil)
        navigationBar.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 17),.foregroundColor: UIColor.white]
        navigationBar.barStyle = .black
        navigationBar.barTintColor = UIColor.black
        navigationBar.tintColor = UIColor.white
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        switch sourceType {
        case .photoLibrary:
            pushViewController(XHPhotoAlbumViewController(), animated: false)
        default:
            pushViewController(XHCameraViewController(), animated: false)
        }
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count < 2 {
            viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissSelf))
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func dismissSelf() {
        _delegate?.imagePickerControllerDidCancel(self)
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


