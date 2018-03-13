//
//  XHHomeChannelController.swift
//  Headline
//
//  Created by Li on 2018/3/13.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHHomeChannelController: UIViewController,XHPageController {
    
    var category: XHHomeChannel.XHChannelCategory! {
        didSet {
            //根据类别进行布局
        }
    }
    
    var isInReuse: Bool = true
    
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        category.queryNews { arr in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
