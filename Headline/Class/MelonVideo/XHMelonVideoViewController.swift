//
//  XHMelonVideoViewController.swift
//  Headline
//
//  Created by Li on 2018/3/12.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit
import LocalAuthentication

class XHMelonVideoViewController: XHViewController,XHTabBarItemController {

    var tabBarItemImageName: String {
        return "video"
    }
    
    var editImageView = UIImageView(frame: CGRect(x: 100, y: 400, width: 100, height: 100))
    
    lazy var touchIDContext: LAContext = {
        let temp = LAContext()
        temp.localizedFallbackTitle = "请输入密码"
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        imageView.image = UIImage(named: "zrx1.jpg")
        view.addSubview(imageView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        imageView.addGestureRecognizer(longPress)
        let button = UIButton(type: .system)
        button.setTitle("拍照或选照片", for: .normal)
        button.frame = CGRect(x: 100, y: 300, width: 100, height: 50)
        view.addSubview(button)
        button.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
        view.addSubview(editImageView)
        let searchButton = UIButton(type: .system)
        searchButton.setTitle("搜索", for: .normal)
        searchButton.frame = CGRect(x: 100, y: 360, width: 100, height: 50)
        view.addSubview(searchButton)
        searchButton.addTarget(self, action: #selector(searchSomething), for: .touchUpInside)
        view.addSubview(editImageView)
        var error: NSError?
        if touchIDContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let touchIdButton = UIButton(type: .system)
            touchIdButton.setTitle("验证touchID", for: .normal)
            view.addSubview(touchIdButton)
            touchIdButton.frame = CGRect(x: 100, y: editImageView.frame.maxY + 10, width: 100, height: 100)
            touchIdButton.addTarget(self, action: #selector(callTouchID), for: .touchUpInside)
        } else {
            if let error = error as? LAError {
                print(error.code.rawValue)
            }
        }
    }
    
    @objc func callTouchID() {
        touchIDContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "验证touchID") { (succeed, error) in
            if succeed {
                DispatchQueue.main.async {
                    print("验证通过")
                }
            } else {
                if let error = error as? LAError {
                    switch error.code {
                    case .authenticationFailed:
                        print("验证失败")
                    case .userCancel:
                        print("用户取消")
                    case .userFallback:
                        print("用户选择手动输入密码")
                    case .systemCancel:
                        print("系统取消")
                    case .passcodeNotSet:
                        print("无法调用touchID，用户未设置密码")
                    case .touchIDNotAvailable:
                        print("touchID无效")
                    case .touchIDNotEnrolled:
                        print("无法调用touchID，用户未设置touchID")
                    case .touchIDLockout:
                        print("touchID被锁定，用户连续多次验证失败")
                    case .appCancel:
                        print("当前App被挂起，取消授权")
                    case .invalidContext:
                        print("上下文无效")
                    case .notInteractive:
                        print("无交互")
                    }
                }
            }
        }
    }
    
    @objc private func handleLongPress(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            registerForPreviewing(with: self, sourceView: longPress.view!)
            
        }
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
        let imageNames = ["zrx1.jpg","zrx2.jpg","zrx3.jpg","zrx4.jpg","zrx5.jpg"]
        var objects = [XHImageViewerObject]()
        for imageName in imageNames {
            let object = XHImageViewerObject(imageViewerable: imageName)
            objects.append(object)
        }
        let imageViewer = XHImageViewerController(images: objects, with: tap.view as! UIImageView, at: 0)
        present(imageViewer, animated: true, completion: nil)
    }
    
    @objc private func selectPhoto() {
        let sheet = UIAlertController(title: "拍照或选照片", message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { [weak self](_) in
            self?.selectedPhoto(with: .camera)
        }))
        sheet.addAction(UIAlertAction(title: "选多张照片", style: .default, handler: { [weak self](_) in
            self?.selectedPhoto(with: .photoLibrary, viewerType: .mutable)
        }))
        sheet.addAction(UIAlertAction(title: "选单张照片", style: .default, handler: { [weak self](_) in
            self?.selectedPhoto(with: .photoLibrary)
        }))
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
        
    }
    
    private func selectedPhoto(with sourceType: XHImagePickerControllerSourceType,viewerType: XHPhotoViewerType = .single) {
        let imagePicker = XHImagePickerController(sourceType: sourceType, for: viewerType)
        imagePicker.maxSelectedCount = 10
        imagePicker._delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc private func searchSomething() {
        let searchController = XHSearchPromptsController()
        present(searchController, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension XHMelonVideoViewController: XHImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: XHImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: XHImagePickerController, didFinishPickingPhotos photos: [XHPhoto]) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: XHImagePickerController, didFinishPickingPhoto photo: XHPhoto, editImage: UIImage?) {
        editImageView.image = editImage
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: XHImagePickerController, didFinishTakingPhoto data: Data?) {
        editImageView.image = UIImage(data: data!)
        picker.dismiss(animated: true, completion: nil)
    }
}

extension XHMelonVideoViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let touchImageController = XHTouchImageViewController()
        return touchImageController
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
    
}
