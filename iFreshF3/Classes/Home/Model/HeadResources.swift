//
//  HeadResources.swift
//  iFreshF
//
//  Created by Jion on 16/5/3.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class HeadResources: NSObject,DictModelProtocol {

   @objc var msg: String?
   @objc var reqid: String?
   @objc var data: HeadData?
    
    class func loadHomeHeadData(completion:(_ data: HeadResources?,_ error: NSError?) -> Void) {
        let path = Bundle.main.path(forResource:"首页焦点按钮", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments)) as! NSDictionary
            let data = DictModelManager.sharedManager.objectWithDictionary(dict: dict as! Dictionary<String, Any>, cls: HeadResources.self) as? HeadResources
            completion(data, nil)
        }
        
    }
    
    static func customClassMapping() -> [String : String]? {
        return ["data" : "\(HeadData.self)"]
    }
}

class HeadData: NSObject,DictModelProtocol {
   @objc var focus: [Activities]?
   @objc var icons: [Activities]?
   @objc var activities: [Activities]?
    
    static func customClassMapping() -> [String : String]? {
        return ["focus" : "\(Activities.self)", "icons" : "\(Activities.self)", "activities" : "\(Activities.self)"]
    }
}

class Activities: NSObject {
   @objc var id: String?
   @objc var name: String?
   @objc var img: String?
   @objc var topimg: String?
   @objc var jptype: String?
   @objc var trackid: String?
   @objc var mimg: String?
   @objc var customURL: String?
}







//end
