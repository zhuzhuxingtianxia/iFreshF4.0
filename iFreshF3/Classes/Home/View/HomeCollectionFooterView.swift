//
//  HomeCollectionFooterView.swift
//  iFreshF
//
//  Created by Jion on 16/5/4.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class HomeCollectionFooterView: UICollectionReusableView {
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "点击查看更多商品 >"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = UIColor.colorWithRGB(r: 150, g: 150, b: 150)
        titleLabel.frame = CGRect(x:0, y:0, width:ZJScreenWidth, height:60)
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideLabel()  {
        self.titleLabel.isHidden = true
    }
    
    func showLabel() {
        self.titleLabel.isHidden = false
    }
    
    func setFooterTitle(text: String, textColor: UIColor) {
        titleLabel.text = text
        titleLabel.textColor = textColor
    }
}

class HomeCollectionHeaderView: UICollectionReusableView {
    private let titleLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = "新鲜热卖"
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.frame = CGRect(x:10, y:0, width:200, height:20)
        titleLabel.textColor = UIColor.colorWithRGB(r: 150, g: 150, b: 150)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




//end
