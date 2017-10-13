//
//  YellowShopCarView.swift
//  iFreshF
//
//  Created by Jion on 16/5/9.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class YellowShopCarView: UIView {

    private var shopViewClick: (() -> ())?
    private let yellowImageView = UIImageView()
    private let redDot = ShopCarRedDotView.sharedRedDotView
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x:frame.origin.x, y:frame.origin.y, width:61, height:61))
        
        clipsToBounds = false
        yellowImageView.image = UIImage(named: "v2_shopNoBorder")
        yellowImageView.frame = CGRect(x:0, y:0, width:61, height:61)
        addSubview(yellowImageView)
        
        let shopCarImageView = UIImageView(image: UIImage(named: "v2_whiteShopBig"))
        shopCarImageView.frame = CGRect(x:(61 - 45) * 0.5, y:(61 - 45) * 0.5, width:45, height:45)
        addSubview(shopCarImageView)
        
        redDot.frame = CGRect(x:frame.size.width - 20, y:0, width:20, height:20)
        addSubview(redDot)
        
        isUserInteractionEnabled = true
        
    }
    
    convenience init(frame: CGRect, shopViewClick: @escaping (() -> ())) {
        self.init(frame:frame)
        let tap = UITapGestureRecognizer(target: self, action: #selector(YellowShopCarView.shopViewShowShopCar))
        addGestureRecognizer(tap)
        self.shopViewClick = shopViewClick
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func shopViewShowShopCar() {
        if shopViewClick != nil {
            shopViewClick!()
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
