//
//  BuyView.swift
//  iFreshF
//
//  Created by Jion on 16/5/3.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class BuyView: UIView {

    var clickAddShopCar:(() -> ())?
   var zeroIsShow = false
    
    //添加按钮
    private lazy var addGoodsButton:UIButton = {
        let addGoodsButton = UIButton(type: UIButtonType.custom)
        addGoodsButton.setImage(UIImage(named:"v2_increase"), for: UIControlState.normal)
        addGoodsButton.addTarget(self, action: #selector(BuyView.addGoodsButtonClick), for: UIControlEvents.touchUpInside)
        
        return addGoodsButton
    }()
    //删除按钮
    private lazy var reduceGoodsButton:UIButton = {
        let reduceGoodsButton = UIButton(type: UIButtonType.custom)
        reduceGoodsButton.setImage(UIImage(named:"v2_reduce"), for: UIControlState.normal)
        reduceGoodsButton.addTarget(self, action: #selector(BuyView.reduceGoodsButtonClick), for: UIControlEvents.touchUpInside)
        reduceGoodsButton.isHidden = false
        return reduceGoodsButton
    }()
    
    //购买数量
    private lazy var buyCountLabel: UILabel = {
        let buyCountLabel = UILabel()
        buyCountLabel.isHidden = false
        buyCountLabel.text = "0"
        buyCountLabel.textColor = UIColor.black
        buyCountLabel.textAlignment = NSTextAlignment.center
        buyCountLabel.font = HomeCollectionTextFont
        return buyCountLabel
    }()
    
    //补货中
    private lazy var supplementLabel:UILabel = {
        let supplementLabel = UILabel()
        supplementLabel.text = "补货中"
        supplementLabel.isHidden = true
        supplementLabel.textAlignment = NSTextAlignment.right
        supplementLabel.textColor = UIColor.red
        supplementLabel.font = HomeCollectionTextFont
        return supplementLabel
    }()
    
    //购买数量
    private var buyNumber: Int = 0 {
        willSet{
            if newValue > 0 {
                reduceGoodsButton.isHidden = false
                buyCountLabel.text = "\(newValue)"
            }else{
                reduceGoodsButton.isHidden = true
                buyCountLabel.isHidden = false
                buyCountLabel.text = "\(newValue)"
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(addGoodsButton)
        addSubview(reduceGoodsButton)
        addSubview(buyCountLabel)
        addSubview(supplementLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buyCountWith: CGFloat = 25
        addGoodsButton.frame = CGRect(x:width - height - 2, y:0, width:height, height:height)
        buyCountLabel.frame = CGRect(x:addGoodsButton.frame.minX - buyCountWith, y:0, width:buyCountWith, height:height)
        reduceGoodsButton.frame = CGRect(x:buyCountLabel.frame.minX - height, y:0, width:height, height:height)
        supplementLabel.frame = CGRect(x:reduceGoodsButton.frame.minX, y:0, width:height + buyCountWith + height, height:height)
    }
    //商品模型Set方法
    var goods:Goods? {
        didSet {
            buyNumber = goods!.userBuyNumber
            if (goods?.number)! <= 0 {
                showSupplementLabel()
            }else{
                hideSupplementLabel()
            }
            
            if 0 == buyNumber {
                reduceGoodsButton.isHidden = true && !zeroIsShow
                buyCountLabel.isHidden = true && !zeroIsShow
            }else{
                reduceGoodsButton.isHidden = false
                buyCountLabel.isHidden = false
            }
        }
    }
    
    /// 显示补货中
    private func showSupplementLabel() {
        supplementLabel.isHidden = false
        addGoodsButton.isHidden = true
        reduceGoodsButton.isHidden = true
        buyCountLabel.isHidden = true
    }
    
    /// 隐藏补货中,显示添加按钮
    private func hideSupplementLabel() {
        supplementLabel.isHidden = true
        addGoodsButton.isHidden = false
        reduceGoodsButton.isHidden = false
        buyCountLabel.isHidden = false
    }
    
    
    // MARK: - Action
    @objc func addGoodsButtonClick() {
        if buyNumber >= (goods?.number)! {
            //发库存不足的通知
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: HomeGoodsInventoryProblem), object: goods?.name)
            return
        }
        
        reduceGoodsButton.isHidden = false
        buyNumber += 1
        goods?.userBuyNumber = buyNumber
        buyCountLabel.text = "\(buyNumber)"
        buyCountLabel.isHidden = false
        
        if clickAddShopCar != nil {
            clickAddShopCar!()
        }
        
        ShopCarRedDotView.sharedRedDotView.addProductToRedDotView(animation: true)
        UserShopCarTool.sharedUserShopCar.addSupermarkProductToShopCar(goods: goods!)
        //发送通知购物价格改变
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:LFBShopCarBuyPriceDidChangeNotification), object: nil, userInfo: nil)
        
    }

    @objc func reduceGoodsButtonClick() {
        if buyNumber <= 0 {
            return
        }
        
        buyNumber -= 1
        goods?.userBuyNumber = buyNumber
        if buyNumber == 0 {
            reduceGoodsButton.isHidden = true && !zeroIsShow
            buyCountLabel.isHidden = true && !zeroIsShow
            buyCountLabel.text = zeroIsShow ? "0" : ""
            UserShopCarTool.sharedUserShopCar.removeSupermarketProduct(goods: goods!)
        } else {
            buyCountLabel.text = "\(buyNumber)"
        }
        
        ShopCarRedDotView.sharedRedDotView.reduceProductToRedDotView(animation: true)
         //发送通知购物价格改变
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:LFBShopCarBuyPriceDidChangeNotification), object: nil, userInfo: nil)
        
    }

}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */
