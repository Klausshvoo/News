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
            DispatchQueue.main.async {[weak self] in
                self?.configureCamera()
            }
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
    
    private lazy var camera = XHCameraView(frame: UIScreen.main.bounds)
    
    private func configureCamera() {
        if #available(iOS 11.0, *) {} else {
            automaticallyAdjustsScrollViewInsets = false
        }
        navigationController?.isNavigationBarHidden = true
        view.addSubview(camera)
        if !camera.createCamera() {
            print("相机存在问题")
        }
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.red
        view.addSubview(button)
        button.frame = CGRect(x: 140, y: 500, width: 40, height: 40)
        button.addTarget(self, action: #selector(takePhoto), for: .touchUpOutside)
    }
    
    @objc private func takePhoto() {
        camera.takePhoto { [weak self](data) in
            if let navigation = self?.navigationController as? XHImagePickerController {
                navigation._delegate?.imagePickerController?(navigation, didFinishTakingPhoto: data)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class XHCameraView: UIView,AVCaptureVideoDataOutputSampleBufferDelegate {
    
    private let device: AVCaptureDevice = AVCaptureDevice.default(for: .video)!
    
    private var input: AVCaptureDeviceInput!
    
    private lazy var imageOutput: AVCaptureStillImageOutput = {
        let temp = AVCaptureStillImageOutput()
        if #available(iOS 11.0, *) {
            temp.outputSettings = [AVVideoCodecKey: AVVideoCodecType.jpeg]
        } else {
            temp.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        }
        return temp
    }()
    
    private lazy var videoOutput: AVCaptureVideoDataOutput = {
        let temp = AVCaptureVideoDataOutput()
        
        return temp
    }()
    
    private let session: AVCaptureSession = AVCaptureSession()
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
    
    var orientation: AVCaptureVideoOrientation {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .portrait
        }
        
    }
    
    func createCamera() -> Bool {
        do {
           input = try AVCaptureDeviceInput(device: device)
        } catch {
            return false
        }
        session.startRunning()
        session.sessionPreset = .high
        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            return false
        }
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = bounds
        layer.addSublayer(previewLayer)
        return true
    }
    
    func takePhoto(completion:@escaping (Data?) -> Void) {
        guard session.canAddOutput(imageOutput) else {
            completion(nil)
            return
        }
        session.addOutput(imageOutput)
        if let connection = imageOutput.connection(with: .video) {
            connection.videoOrientation = orientation
            connection.videoScaleAndCropFactor = 1.0
            imageOutput.captureStillImageAsynchronously(from: connection, completionHandler: { [weak self](buffer, error) in
                self?.session.removeOutput(self!.imageOutput)
                if let buffer = buffer {
                    let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                    completion(data)
                } else {
                    completion(nil)
                }
            })
        }
    }
}
