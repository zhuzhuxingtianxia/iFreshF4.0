//
//  NotSearchProductsView.swift
//  iFreshF
//
//  Created by Jion on 16/5/20.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class NotSearchProductsView: UIView {

   private let topBackView = UIView()
    private let markImageView = UIImageView()
    private let productLabel = UILabel()
    private let searchLabel = UILabel()
    private let titleLabel = UILabel()
    private var tapAction:(() -> ())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        topBackView.frame = CGRect(x:0, y:0, width:width, height:50)
        topBackView.backgroundColor = UIColor.colorWithRGB(r: 249, g: 242, b: 216)
        addSubview(topBackView)
        
        markImageView.contentMode = UIViewContentMode.scaleAspectFill
        markImageView.image = UIImage(named: "icon_exclamationmark")
        markImageView.frame = CGRect(x:15, y:(50 - 27) * 0.5, width:27, height:27)
        addSubview(markImageView)
        
        productLabel.textColor = UIColor.colorWithRGB(r: 148, g: 107, b: 81)
        productLabel.font = UIFont.systemFont(ofSize: 14)
        productLabel.frame = CGRect(x:markImageView.frame.maxX + 10, y:10, width:width * 0.7, height:15)
        productLabel.text = "暂时没搜到〝星巴克〞相关商品"
        addSubview(productLabel)
        
        searchLabel.textColor = UIColor.colorWithRGB(r: 252, g: 185, b: 47)
        searchLabel.font = UIFont.systemFont(ofSize: 12)
        searchLabel.text = "没有搜到你要的商品，换其他关键词试试看~"
        searchLabel.frame = CGRect(x:productLabel.x, y:productLabel.frame.maxY + 5, width:width * 0.7, height:15)
        addSubview(searchLabel)
        
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.text = "大家都在买"
        titleLabel.frame = CGRect(x:10, y:60, width:200, height:15)
        addSubview(titleLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(NotSearchProductsView.tapActionClick))
        addGestureRecognizer(tap)
    }
    
    convenience init(frame: CGRect,tapAction:@escaping (() -> ())) {
        self.init(frame:frame)
        
        self.tapAction = tapAction
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSearchProductLabelText(text: String) {
        productLabel.text = "暂时没搜到" + "〝" + text + "〞" + "相关商品"
    }
    
    @objc func tapActionClick() {
        if self.tapAction != nil {
            self.tapAction!()
        }
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */
