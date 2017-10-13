//
//  UserShopCarTool.swift
//  iFreshF
//
//  Created by Jion on 16/5/9.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class UserShopCarTool: NSObject {

    private static let instance = UserShopCarTool()
    
    private var supermarketProducts = [Goods]()
    
    class var sharedUserShopCar: UserShopCarTool {
        return instance
    }
    
    //添商品到购物车
    func addSupermarkProductToShopCar(goods: Goods) {
        for everyGoods in supermarketProducts {
            if everyGoods.id == goods.id {
                return
            }
        }
        
        supermarketProducts.append(goods)
    }
    //减商品到购物车
    func removeSupermarketProduct(goods: Goods) {
        for i in 0..<supermarketProducts.count {
            let everyGoods = supermarketProducts[i]
            if everyGoods.id == goods.id {
                supermarketProducts.remove(at: i)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LFBShopCarDidRemoveProductNSNotification), object: nil, userInfo: nil)

                return
            }
        }
    }
    //判断购物车是否有商品
    func isEmpty() -> Bool {
        return supermarketProducts.count <= 0
    }
    //获取购物车产品
    func getShopCarProducts() -> [Goods] {
        return supermarketProducts
    }
    //购物车中产品种类的数量
    func getShopCarProductsClassifNumber() -> Int {
        return supermarketProducts.count
    }
    //用户购买的总数量
    func userShopCarProductsNumber() -> Int {
        return ShopCarRedDotView.sharedRedDotView.buyNumber
    }
    //计算商品的总价
    func getAllProductsPrice() -> String {
        var allPrice: Double = 0
        for goods in supermarketProducts {
            allPrice = allPrice + Double(goods.price!)! * Double(goods.userBuyNumber)
        }
        
        return "\(allPrice)".cleanDecimalPointZero()
    }

}
