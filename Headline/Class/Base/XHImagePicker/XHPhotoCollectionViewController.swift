//
//  XHPhotoCollectionViewController.swift
//  Headline
//
//  Created by Li on 2018/3/27.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHPhotoCollectionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        print("456")
        let nav = navigationController as! XHImagePickerController
        nav.photoManager.fetchAllPhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // 取出所有相机胶卷资源
    
}
