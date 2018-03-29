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
        title = "相册"
        handleAuthorizationStatus(PHPhotoLibrary.authorizationStatus())
    }
    
    private var albums: [XHPhotoAlbum]?
    
    private var userLibrary: XHPhotoAlbum!
    
    private lazy var tableView: UITableView = {
        let temp = UITableView(frame: UIScreen.main.bounds, style: .plain)
        temp.register(XHAlbumCell.self, forCellReuseIdentifier: "cell")
        temp.dataSource = self
        temp.delegate = self
        temp.rowHeight = 80
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
                let userLibrary = XHPhotoAlbum.userLibrary
                photoCollectionController.photoAblum = userLibrary
                self?.userLibrary = userLibrary
                self?.navigationController?.pushViewController(photoCollectionController, animated: false)
                self?.navigationController?.delegate = self
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
    
    private func configureForAlbums() {
        view.addSubview(tableView)
        DispatchQueue.global().async {[weak self] in
            self?.albums = XHPhotoAlbum.fetchAllAblums()
            self?.albums?[0] = self!.userLibrary
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! XHAlbumCell
        let album = albums![indexPath.row]
        cell.setAlbum(album)
        return cell
    }
    
}

extension XHPhotoAlbumViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let album = albums![indexPath.row]
        let colletion = XHPhotoCollectionViewController()
        colletion.photoAblum = album
        navigationController?.pushViewController(colletion, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension XHPhotoAlbumViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController == self {
            navigationController.delegate = nil
            configureForAlbums()
        }
    }
    
}

private class XHAlbumCell: UITableViewCell {
    
    private let coverImageView = UIImageView()
    
    private let titleLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        coverImageView.backgroundColor = UIColor.red
        contentView.addSubview(coverImageView)
        contentView.addSubview(titleLabel)
        coverImageView.translatesAutoresizingMaskIntoConstraints = false
        coverImageView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor).isActive = true
        coverImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        coverImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        coverImageView.widthAnchor.constraint(equalTo: coverImageView.heightAnchor).isActive = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: coverImageView.rightAnchor, constant: 5).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var index: Int?
    
    private var _photo: XHPhoto?
    
    func setAlbum(_ album: XHPhotoAlbum) {
        titleLabel.text = "\(album.localizedTitle!)(\(album.count))"
        _photo = album.coverPhoto
        index = _photo?.fetchPhoto(in: CGSize(width: 70, height: 70), completion: { [weak self](image) in
            self?.coverImageView.image = image
        })
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let index = self.index {
            _photo?.closeClosure(for: coverImageView.bounds.size, at: index)
        }
    }
    
}
