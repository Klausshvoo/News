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
        navigationController?.delegate = self
    }
    
    private var albums: [XHPhotoAlbum]?
    
    private lazy var tableView: UITableView = {
        let temp = UITableView(frame: UIScreen.main.bounds, style: .plain)
        temp.dataSource = self
        return temp
    }()
    
    private func handleAuthorizationStatus(_ status: PHAuthorizationStatus) {
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ [weak self](status) in
                self?.handleAuthorizationStatus(status)
            })
        case .authorized:
            DispatchQueue.main.async {[weak self] in
                let photoCollectionController = XHPhotoCollectionViewController()
                photoCollectionController.photoAblum = XHPhotoAlbum.userLibrary
                self?.navigationController?.pushViewController(photoCollectionController, animated: false)
            }
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

extension XHPhotoAlbumViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
}

extension XHPhotoAlbumViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
}
