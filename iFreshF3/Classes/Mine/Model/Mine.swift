//
//  Mine.swift
//  iFreshF
//
//  Created by Jion on 16/4/20.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class Mine: NSObject,DictModelProtocol {
   @objc var code: Int = -1
   @objc var msg: String?
   @objc var reqid: String?
   @objc var data: MineData?
    
    class func loadMineData(completion:(_ data: Mine?,_ error: NSError?) -> Void) {
        let path = Bundle.main.path(forResource: "Mine", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        
        if data != nil {
            let dict:NSDictionary = (try! JSONSerialization.jsonObject(with: data! as Data, options: .allowFragments)) as! NSDictionary
            let modelTool = DictModelManager.sharedManager
            let data = modelTool.objectWithDictionary(dict: dict as! Dictionary<String, Any>, cls: Mine.self) as? Mine
            completion(data, nil)
        }
    }
    
    static func customClassMapping() -> [String : String]? {
        let dic = ["data" : "\(MineData.self)"]
        return dic
    }

}

class MineData: NSObject {
   @objc var has_new: Int = -1
   @objc var has_new_user: Int = -1
   @objc var availble_coupon_num = 0
}
