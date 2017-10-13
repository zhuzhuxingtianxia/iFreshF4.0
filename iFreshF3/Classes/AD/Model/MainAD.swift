//
//  MainAD.swift
//  iFreshF
//
//  Created by Jion on 16/4/11.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class MainAD: NSObject,DictModelProtocol {

   @objc var code: NSInteger = -1
   @objc var msg: String?
   @objc var data: AD?
    
    class func loadADData(completion:(_ data: MainAD?,_ error: NSError?) ->Void){
        let path = Bundle.main.path(forResource:"AD", ofType: nil)
        let datas = NSData(contentsOfFile: path!)
        if datas != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: datas! as Data, options: JSONSerialization.ReadingOptions.allowFragments)) as! NSDictionary
            let modelTool = DictModelManager.sharedManager
            let data = modelTool.objectWithDictionary(dict: dict as! Dictionary<String, Any>, cls: MainAD.self) as? MainAD
            
            completion(data, nil)
            
        }
    }
    
    static func customClassMapping() -> [String : String]? {
        return ["data" : "\(AD.self)"]
    }
}

class AD: NSObject {
   @objc var title: String?
   @objc var img_name: String?
   @objc var starttime: String?
   @objc var endtime: String?
}
