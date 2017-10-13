//
//  ShopCartFooterView.swift
//  iFreshF
//
//  Created by Jion on 16/5/13.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

@objc protocol ShopCartSupermarketTableFooterViewDelegate: NSObjectProtocol {
    
   @objc optional func supermarketTableFooterDetermineButtonClick();
}

class ShopCartFooterView: UIView {

    private let titleLabel  = UILabel()
    let priceLabel = UILabel()
    private let determineButton = UIButton()
    private var backView = UIView()
    weak var delegate: ShopCartSupermarketTableFooterViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backView.frame = CGRect(x:0, y:0, width:ZJScreenWidth, height:ShopCartRowHeight)
        backView.backgroundColor = UIColor.white
        addSubview(backView)
        
        titleLabel.text = "共$ "
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.sizeToFit()
        titleLabel.textColor = UIColor.red
        titleLabel.frame = CGRect(x:15, y:0, width:titleLabel.width, height:ShopCartRowHeight)
        addSubview(titleLabel)
        
        priceLabel.font = UIFont.systemFont(ofSize: 14)
        priceLabel.textColor = UIColor.red
        priceLabel.frame = CGRect(x:titleLabel.frame.maxX, y:0, width:ZJScreenWidth * 0.5, height:ShopCartRowHeight)
        priceLabel.text = UserShopCarTool.sharedUserShopCar.getAllProductsPrice()
        addSubview(priceLabel)
        
        determineButton.frame = CGRect(x:ZJScreenWidth - 90, y:0, width:90, height:ShopCartRowHeight)
        determineButton.backgroundColor = LFBNavigationYellowColor
        determineButton.setTitle("选好了", for: UIControlState.normal)
        determineButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        determineButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        determineButton.addTarget(self, action: #selector(ShopCartFooterView.determineButtonClick), for: UIControlEvents.touchUpInside)
        addSubview(determineButton)
        
        addSubview(lineView(frame: CGRect(x:0, y:ShopCartRowHeight - 0.5, width:ZJScreenWidth, height:0.5)))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func determineButtonClick() {
        
        if delegate != nil && delegate!.responds(to: #selector(ShopCartSupermarketTableFooterViewDelegate.supermarketTableFooterDetermineButtonClick)) {
            
             delegate?.supermarketTableFooterDetermineButtonClick!()
        }
       
    }
    private func lineView(frame: CGRect) -> UIView {
        let lineView = UIView(frame: frame)
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        return lineView
    }


}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */
