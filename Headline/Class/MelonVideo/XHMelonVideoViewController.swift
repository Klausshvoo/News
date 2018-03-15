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

        // Do any additional setup after loading the view.
        let layer = CALayer()
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.backgroundColor = UIColor.red.cgColor
        view.layer.addSublayer(layer)
        print(layer.anchorPoint)
//        layer.anchorPoint = CGPoint(x: 1, y: 1)
        layer.position = CGPoint(x: 100, y: 100)
        print(layer.anchorPoint)
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
