//
//  NewsCell.swift
//  NewsUIKit
//
//  Created by Mr.wu on 2019/7/10.
//  Copyright © 2019 Mr.wu. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    let imgView = UIImageView()
    let titleLabel = UILabel()
    let sourceLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imgView.contentMode = .scaleAspectFill
        imgView.layer.masksToBounds = true
        titleLabel.numberOfLines = 2
        sourceLabel.textColor = UIColor.gray
        sourceLabel.font = UIFont.systemFont(ofSize: 12)
        selectionStyle = .none
        
        addSubview(imgView)
        addSubview(titleLabel)
        addSubview(sourceLabel)
        
        imgView.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().inset(20)
            maker.top.bottom.equalToSuperview().inset(20)
            maker.width.equalTo(imgView.snp.height).multipliedBy(2)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.left.top.equalToSuperview().inset(20)
            maker.right.equalTo(imgView.snp.left).offset(-20)
        }
        sourceLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel)
            maker.bottom.equalTo(imgView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
