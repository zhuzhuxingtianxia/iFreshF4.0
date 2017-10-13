//
//  AdressData.swift
//  iFreshF
//
//  Created by Jion on 16/4/18.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class AdressData: NSObject,DictModelProtocol {
   @objc var code: Int = -1
   @objc var msg: String?
   @objc var data: [Adress]?
    
    static func customClassMapping() -> [String : String]? {
        return ["data": "\(Adress.self)"]
    }
    
    class func loadMyAdressData(completion:(_ data: AdressData?, _ error: NSError?) -> Void){
        let path = Bundle.main.path(forResource:"MyAdress", ofType: nil)
        let data = NSData(contentsOfFile: path!)
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments)) as! NSDictionary
            let modelTool = DictModelManager.sharedManager
            let data = modelTool.objectWithDictionary(dict: dict as! Dictionary<String, Any>, cls: AdressData.self) as? AdressData
            completion(data, nil)
        }
    }
    
}

class Adress: NSObject {
    
   @objc var accept_name: String?
   @objc var telphone: String?
   @objc var province_name: String?
   @objc var city_name: String?
   @objc var address: String?
   @objc var lng: String?
   @objc var lat: String?
   @objc var gender: String?
}
