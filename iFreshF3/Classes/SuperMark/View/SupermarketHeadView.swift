//
//  SupermarketHeadView.swift
//  iFreshF
//
//  Created by Jion on 16/5/9.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class SupermarketHeadView: UITableViewHeaderFooterView {

    var titleLabel: UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        backgroundView = UIView()
        backgroundView?.backgroundColor = UIColor.clear
        
        contentView.backgroundColor = UIColor(red: 240 / 255.0, green: 240 / 255.0, blue: 240 / 255.0, alpha: 0.8)
        buildTitleLabel()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x:HotViewMargin, y:0, width:width - HotViewMargin, height:height)
    }
    
    private func buildTitleLabel() {
        titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.textColor = UIColor.colorWithRGB(r: 100, g: 100, b: 100)
        titleLabel.textAlignment = NSTextAlignment.left
        contentView.addSubview(titleLabel)
    }
  

}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */
