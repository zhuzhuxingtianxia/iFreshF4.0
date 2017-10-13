//
//  SearchProducts.swift
//  iFreshF
//
//  Created by Jion on 16/5/19.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class SearchProducts: NSObject,DictModelProtocol {

   @objc var code: Int = -1
   @objc var msg: String?
   @objc var reqid: String?
   @objc var data: [Goods]?
    
    class func loadSearchData(completion:((_ data: SearchProducts?, _ error: NSError?) -> Void)) {
        let path = Bundle.main.path(forResource:"促销", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)) as! NSDictionary
            let modelTool = DictModelManager.sharedManager
            let data = modelTool.objectWithDictionary(dict: dict as! Dictionary<String, Any>, cls: SearchProducts.self) as? SearchProducts
            completion(data, nil)
        }
    }

    static func customClassMapping() -> [String : String]? {
        return ["data" : "\(Goods.self)"]
    }
}
