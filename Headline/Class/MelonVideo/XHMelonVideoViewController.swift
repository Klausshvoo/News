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
    }
    
    @objc func handleTap(_ tap: UITapGestureRecognizer) {
//        let imageNames = ["zrx1.jpg","zrx2.jpg","zrx3.jpg","zrx4.jpg","zrx5.jpg"]
//        var objects = [XHImageViewerObject]()
//        for imageName in imageNames {
//            let object = XHImageViewerObject(imageViewerable: imageName)
//            objects.append(object)
//        }
//        let imageViewer = XHImageViewerController(images: objects, with: tap.view as! UIImageView, at: 0)
        let imagePicker = XHImagePickerController(sourceType: .camera)
        present(imagePicker, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
