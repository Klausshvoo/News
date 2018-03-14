//
//  XHHomeNewsCell.swift
//  Headline
//
//  Created by Li on 2018/3/14.
//  Copyright © 2018年 Personal. All rights reserved.
//

import UIKit

class XHHomeNewsCell: UITableViewCell {

    let label = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.numberOfLines = 0
        label.snp.makeConstraints{
            $0.top.equalTo(contentView).offset(12)
            $0.left.equalTo(contentView).offset(12)
            $0.right.equalTo(contentView).offset(-12)
        }
    }
    
    func setText(text: String?)  {
        label.text = text
        setAutoHeight(bottomView: label, bottomMargin: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension XHHomeNewsCell: XHTableViewCellAutoHeight {}
