//
//  XHImagePickerController.swift
//  Headline
//
//  Created by Li on 2018/3/27.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

enum XHImagePickerControllerSourceType {
    
    case photoLibrary(XHPhotoViewerType),camera

}

enum XHPhotoViewerType {
    
    case mutable,single
    
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
    
    internal(set) var viewerType: XHPhotoViewerType?
    
    init(sourceType: XHImagePickerControllerSourceType) {
        self.sourceType = sourceType
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
        case .photoLibrary(let viewerType):
            self.viewerType = viewerType
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


