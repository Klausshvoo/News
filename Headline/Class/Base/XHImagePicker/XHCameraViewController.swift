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
    
    private var camera: XHCameraView?
    
    private func configureCamera() {
        if #available(iOS 11.0, *) {} else {
            automaticallyAdjustsScrollViewInsets = false
        }
        navigationController?.isNavigationBarHidden = true
        do {
            camera = try XHCameraView(position: .back)
            view.addSubview(camera!)
            camera?.translatesAutoresizingMaskIntoConstraints = false
            camera?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            camera?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            camera?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            camera?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        }catch {
            print("相机初始化失败")
        }
        
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.red
        view.addSubview(button)
        button.frame = CGRect(x: 140, y: 500, width: 40, height: 40)
        button.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        let flashButton = UIButton(type: .custom)
        flashButton.setTitle("自动", for: .normal)
        flashButton.setTitleColor(UIColor.blue, for: .normal)
        view.addSubview(flashButton)
        flashButton.frame = CGRect(x: 20, y: 64, width: 40, height: 40)
        flashButton.addTarget(self, action: #selector(handleFlash(_:)), for: .touchUpInside)
        let positionButton = UIButton(type: .custom)
        positionButton.setTitle("切换", for: .normal)
        positionButton.setTitleColor(UIColor.blue, for: .normal)
        view.addSubview(positionButton)
        positionButton.frame = CGRect(x: UIScreen.main.bounds.width - 60, y: 64, width: 40, height: 40)
        positionButton.addTarget(self, action: #selector(changeCamera), for: .touchUpInside)
    }
    
    @objc private func takePhoto() {
        camera?.takePhoto { [weak self](data) in
            if let navigation = self?.navigationController as? XHImagePickerController {
                navigation._delegate?.imagePickerController?(navigation, didFinishTakingPhoto: data)
            }
        }
    }
    
    @objc private func handleFlash(_ sender: UIButton) {
        let arr = ["关","开","自动"]
        let index = (arr.index(of: sender.currentTitle!)! + 1) % 3
        let mode = AVCaptureDevice.FlashMode(rawValue: index)!
        if let camera = self.camera,camera.configureFlash(mode) {
            sender.setTitle(arr[index], for: .normal)
        }
    }
    
    @objc private func changeCamera() {
        if let position = camera?.position {
            switch position {
            case .unspecified:
                break
            case .back:
                camera?.changeCamera(to: .front)
            case .front:
                camera?.changeCamera(to: .back)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

class XHCameraView: UIView {
    
    enum XHCameraError: Error {
        case position,input
    }
    
    private let session: AVCaptureSession = AVCaptureSession()
    
    private lazy var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
    
    private(set) var flashMode: AVCaptureDevice.FlashMode = .auto
    
    private var device: AVCaptureDevice?
    
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
    
    private lazy var focusView: UIView = {
       let temp = UIView()
        temp.bounds = CGRect(x: 0, y: 0, width: 80, height: 80)
        temp.layer.borderWidth = 1.0
        temp.layer.borderColor = UIColor.green.cgColor
        temp.isHidden = true
        return temp
    }()
    
    var position: AVCaptureDevice.Position {
        return device?.position ?? .unspecified
    }
    
    @discardableResult public func changeCamera(to positon: AVCaptureDevice.Position) -> Bool {
        guard self.position != positon else { return true }
        session.stopRunning()
        session.beginConfiguration()
        if let device = changeOverCamera(to: positon) {
            try! configureCamera(device)
            self.device = device
            return true
        }
        session.commitConfiguration()
        return false
    }
    
    convenience init(position: AVCaptureDevice.Position) throws {
        self.init(frame: .zero)
        session.beginConfiguration()
        if session.canSetSessionPreset(.high) {
           session.canSetSessionPreset(.high)
        }
        previewLayer.videoGravity = .resizeAspectFill
        layer.addSublayer(previewLayer)
        if let device = changeOverCamera(to: position) {
            try configureCamera(device)
            self.device = device
        } else {
            throw XHCameraError.position
        }
        addSubview(focusView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }
    
    private func configureCamera(_ device: AVCaptureDevice) throws {
        if self.input != nil {
            session.removeInput(self.input)
            session.removeOutput(imageOutput)
        }
        let input = try AVCaptureDeviceInput(device: device)
        if session.canAddInput(input) {
            session.addInput(input)
            self.input = input
        } else {
            throw XHCameraError.input
        }
        if session.canAddOutput(imageOutput) {
            session.addOutput(imageOutput)
        }
        session.commitConfiguration()
        session.startRunning()
        try device.lockForConfiguration()
        if device.isWhiteBalanceModeSupported(.autoWhiteBalance) {
            device.whiteBalanceMode = .autoWhiteBalance
        }
        if device.isFlashModeSupported(flashMode) {
            device.flashMode = flashMode
        }
        device.unlockForConfiguration()
    }
    
    private func changeOverCamera(to position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.devices(for: .video)
        return devices.filter({ $0.position == position }).first
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer.frame = bounds
        if let device = self.device {
            focusAtPoint(center, for: device)
        }
    }
    
    @discardableResult func configureFlash(_ flashMode: AVCaptureDevice.FlashMode) -> Bool {
        do {
            try device?.lockForConfiguration()
        }catch {
            return false
        }
        device?.flashMode = flashMode
        device?.unlockForConfiguration()
        return true
    }
    
    private func focusAtPoint(_ point: CGPoint,for device: AVCaptureDevice) {
        let focusPoint = CGPoint(x: point.y/bounds.height, y: 1 - point.x / bounds.width)
        try! device.lockForConfiguration()
        if device.isFocusModeSupported(.autoFocus) {
            device.focusPointOfInterest = focusPoint
            device.focusMode = .autoFocus
        }
        if device.isExposureModeSupported(.autoExpose) {
            device.exposurePointOfInterest = focusPoint
            device.exposureMode = .autoExpose
        }
        device.unlockForConfiguration()
    }

    func takePhoto(completion:@escaping (Data?) -> Void) {
        if let connection = imageOutput.connection(with: .video) {
            connection.videoScaleAndCropFactor = 1.0
            imageOutput.captureStillImageAsynchronously(from: connection, completionHandler: { (buffer, error) in
                if let buffer = buffer {
                    let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
                    completion(data)
                } else {
                    completion(nil)
                }
            })
        }
    }
    
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        let point = tap.location(in: self)
        focusAnimation(point)
    }
    
    private func focusAnimation(_ point: CGPoint) {
        if let device = self.device {
            focusAtPoint(point, for: device)
            focusView.center = point
            focusView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {[weak self] in
                self?.focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
                }, completion: { [weak self](_) in
                    UIView.animate(withDuration: 0.3, animations: {
                        self?.focusView.transform = .identity
                    }, completion: { (_) in
                        self?.focusView.isHidden = true
                    })
            })
        }
    }
    
}
