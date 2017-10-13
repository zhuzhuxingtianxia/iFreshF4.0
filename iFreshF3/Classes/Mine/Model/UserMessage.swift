//
//  UserMessage.swift
//  iFreshF
//
//  Created by Jion on 16/5/27.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

enum UserMessageType: Int {
    case System = 0
    case User = 1
}

class UserMessage: NSObject {

   @objc var id: String?
   @objc var type = -1
   @objc var title: String?
   @objc var content: String?
   @objc var link: String?
   @objc var city: String?
   @objc var noticy: String?
   @objc var send_time: String?
    
    // 辅助参数
   @objc var subTitleViewHeightNomarl: CGFloat = 60
   @objc var cellHeight: CGFloat = 60 + 60 + 20
   @objc var subTitleViewHeightSpread: CGFloat = 0
    
    class func loadSystemMessage(complete: ((_ data: [UserMessage]?, _ error: NSError?) -> ())) {
        
        complete(loadMessage(type: .System)!, nil)
    }
    
    class func loadUserMessage(complete: ((_ data: [UserMessage]?, _ error: NSError?) -> ())) {
        complete(loadMessage(type: .User), nil)
    }

    private class func userMessage(dict: NSDictionary) -> UserMessage {
        
        let modelTool = DictModelManager.sharedManager
        let message = modelTool.objectWithDictionary(dict: dict as! Dictionary<String, Any>, cls: UserMessage.self) as? UserMessage
        
        return message!
    }
    
    private class func loadMessage(type: UserMessageType) -> [UserMessage]? {
        var data: [UserMessage]? = []
        
        let path = Bundle.main.path(forResource: ((type == .System) ? "SystemMessage" : "UserMessage"), ofType: nil)
        
        let resDada = try? Data(contentsOf: URL(fileURLWithPath:path!))
        
        do {
            let json = try JSONSerialization.jsonObject(with: resDada!, options: .allowFragments)
            let dict = json as? [String : AnyObject]
            
            if let array = dict?["data"] as? NSArray {
                for subDict in array {
                    let message = UserMessage.userMessage(dict: subDict as! NSDictionary)
                    data?.append(message)
                }
            }
            return data
        } catch {
            return nil
        }
        
        /*
        let resData = NSData(contentsOfFile: path!)
        if resData != nil {
            let dict: Dictionary = (try! JSONSerialization.JSONObjectWithData(resData! as Data, options: .AllowFragments) as! Dictionary)
            if let array = dict.object(forKey: "data") as? NSArray {
                for dict in array {
                    let message = UserMessage.userMessage(dict: dict)
                    data?.append(message)
                }
            }
        }
         
         return data
 */
        
    }

}
