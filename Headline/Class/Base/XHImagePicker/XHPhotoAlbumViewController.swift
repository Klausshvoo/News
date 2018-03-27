//
//  XHPhotoAlbumViewController.swift
//  Headline
//
//  Created by Li on 2018/3/27.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import Photos

class XHPhotoAlbumViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        handleAuthorizationStatus(PHPhotoLibrary.authorizationStatus())
    }
    
    private func handleAuthorizationStatus(_ status: PHAuthorizationStatus) {
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ [weak self](status) in
                self?.handleAuthorizationStatus(status)
            })
        case .authorized:
            navigationController?.pushViewController(XHPhotoCollectionViewController(), animated: false)
        default:
            DispatchQueue.main.async {[weak self] in
                self?.configureForDenied()
            }
        }
    }
    
    private func configureForDenied() {
        let label = UILabel()
        label.text = "请在iPhone的\"设置-隐私-照片\"选项中，\n允许今日头条访问您的手机相册"
        label.textAlignment = .center
        label.numberOfLines = 0
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
