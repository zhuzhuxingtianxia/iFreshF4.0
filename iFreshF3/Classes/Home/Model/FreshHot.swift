//
//  FreshHot.swift
//  iFreshF
//
//  Created by Jion on 16/5/3.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class FreshHot: NSObject, DictModelProtocol {

   @objc var page: Int = -1
   @objc var code: Int = -1
   @objc var msg: String?
   @objc var data:[Goods]?
    class func loadFreshHotData(completion:(_ data: FreshHot?,_ error: NSError?) -> Void) {
        let path = Bundle.main.path(forResource:"首页新鲜热卖", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        if data != nil {
            let dict: Dictionary = (try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments)) as! Dictionary<String, Any>
            let modelTool = DictModelManager.sharedManager
            let data = modelTool.objectWithDictionary(dict: dict, cls: FreshHot.self) as? FreshHot
            completion(data, nil)
        }
    }
    
    static func customClassMapping() -> [String: String]? {
        return ["data":"\(Goods.self)"]
    }
}

class Goods: NSObject {
    //*************************商品模型默认属性**********************************
    //商品ID
   @objc var id: String?
    //商品姓名
   @objc var name: String?
   @objc var brand_id: String?
    //超市价格
   @objc var market_price:String?
   @objc var cid: String?
   @objc var category_id: String?
    //当前价格
   @objc var partner_price: String?
   @objc var brand_name: String?
   @objc var pre_img:String?
    
   @objc var pre_imgs: String?
    //参数
    @objc var specifics: String?
   @objc var product_id: String?
   @objc var dealer_id: String?
    //当前价格
   @objc var price: String?
    //库存
   @objc var number: Int = -1
    //买一赠一
   @objc var pm_desc: String?
   @objc var had_pm: Int = -1
    //urlStr
   @objc var img: String?
   @objc var url: String?
    //是不是精选 0:不是 ，1:是
   @objc var is_xf:Int = 0
    
    //*************************商品模型辅助属性**********************************
    // 记录用户对商品添加次数
   @objc var userBuyNumber: Int = 0
}




//@end
