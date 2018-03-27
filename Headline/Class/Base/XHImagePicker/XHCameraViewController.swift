//
//  XHCameraViewController.swift
//  Headline
//
//  Created by Li on 2018/3/27.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import AVFoundation

class XHCameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        handleAuthorizationStatus(AVCaptureDevice.authorizationStatus(for: .video))
    }

    private func handleAuthorizationStatus(_ status: AVAuthorizationStatus) {
        switch status {
        case .notDetermined:// 开启定时器，检测授权状态改变情况
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self](isAuth) in
                self?.handleAuthorizationStatus(isAuth ? .authorized : .denied)
            })
        case .authorized://进行UI创建
            break
        default:
            DispatchQueue.main.async {[weak self] in
                self?.configureForDenied()
            }
        }
    }
    
    private func configureForDenied() {
        let label = UILabel()
        label.text = "请在iPhone的\"设置-隐私-照片\"选项中，\n允许今日头条访问您的手机相机"
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
