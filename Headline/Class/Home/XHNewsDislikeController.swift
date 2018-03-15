//
//  XHNewsDislikeController.swift
//  Headline
//
//  Created by Li on 2018/3/15.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHNewsDislikeController: XHTriangleViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let width = UIScreen.main.bounds.width - 20
        contentSize = CGSize(width: width, height: width / 2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
