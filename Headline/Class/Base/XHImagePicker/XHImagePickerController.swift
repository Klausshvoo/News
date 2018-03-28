//
//  XHImagePickerController.swift
//  Headline
//
//  Created by Li on 2018/3/27.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

public enum XHImagePickerControllerSourceType : Int {
    
    case photoLibrary
    
    case camera

}

@objc protocol XHImagePickerControllerDelegate: NSObjectProtocol {
    
    @objc optional func imagePickerController(_ picker: XHImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    
    @objc optional func imagePickerControllerDidCancel(_ picker: XHImagePickerController)
    
}

class XHImagePickerController: UINavigationController {
    
    private weak var _delegate: XHImagePickerControllerDelegate? {
        if let temp = delegate,temp.conforms(to: XHImagePickerControllerDelegate.self) {
            return temp as? XHImagePickerControllerDelegate
        }
        return nil
    }
    
    private(set) var sourceType: XHImagePickerControllerSourceType = .photoLibrary
    
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
        _delegate?.imagePickerControllerDidCancel?(self)
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


