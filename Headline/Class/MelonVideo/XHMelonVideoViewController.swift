//
//  XHMelonVideoViewController.swift
//  Headline
//
//  Created by Li on 2018/3/12.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHMelonVideoViewController: XHViewController,XHTabBarItemController {

    var tabBarItemImageName: String {
        return "video"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        imageView.image = UIImage(named: "zrx1.jpg")
        view.addSubview(imageView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        let button = UIButton(type: .system)
        button.setTitle("拍照或选照片", for: .normal)
        button.frame = CGRect(x: 100, y: 300, width: 100, height: 50)
        view.addSubview(button)
        button.addTarget(self, action: #selector(selectPhoto), for: .touchUpInside)
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
            self?.selectedPhoto(with: .photoLibrary(.mutable))
        }))
        sheet.addAction(UIAlertAction(title: "选单张照片", style: .default, handler: { [weak self](_) in
            self?.selectedPhoto(with: .photoLibrary(.single))
        }))
        sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(sheet, animated: true, completion: nil)
        
    }
    
    private func selectedPhoto(with sourceType: XHImagePickerControllerSourceType) {
        let imagePicker = XHImagePickerController(sourceType: sourceType)
        imagePicker._delegate = self
        present(imagePicker, animated: true, completion: nil)
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
    
}
