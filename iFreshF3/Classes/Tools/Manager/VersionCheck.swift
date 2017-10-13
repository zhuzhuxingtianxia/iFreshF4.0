//
//  VersionCheck.swift
//  DecorationLive
//
//  Created by Jion on 15/10/9.
//  Copyright © 2015年 Youjuke. All rights reserved.
//

import UIKit
//  全局公用属性类似宏定义
public let APP_URL:String = "https://itunes.apple.com/lookup?id="
private var downLoadUrl:String!
class VersionCheck: UIView {
}

public func updateVersionWithWindow(window:UIWindow ,appId:NSString)
{
    let check = VersionCheck()
//    window.addSubview(check)
    window.rootViewController?.view.addSubview(check)
    compareVison(appId: appId as String, window:window)
}
/*
   版本检测
*/

private func compareVison(appId:String , window:UIWindow){
    let shortVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
    print("version:\(shortVersion!)")
    let longBuildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
    
    let requestUrl = APP_URL + appId
    let  request = NSMutableURLRequest(url: NSURL(string: requestUrl)! as URL)
    request.httpMethod = "GET"
    
    
    let session = URLSession.shared
    let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
        if data != nil {
            print("itunes request Success")
            let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves) as! NSDictionary
            
            if let resultsArr = dict!["results"] as? NSArray{
                if resultsArr.count>0{
                    if let infoDic = resultsArr[0] as? NSDictionary{
                        let latestVersion = infoDic.object(forKey: "version") as! String
                        downLoadUrl = infoDic.object(forKey: "trackViewUrl") as! String
                        
                        let latest = versionToInt(str: latestVersion)
                        let current = versionToInt(str: longBuildVersion)
                        
                        if latest >= current && latestVersion != longBuildVersion {
                            DispatchQueue.main.async(execute: {
                                alertUpdate(window: window)
                            })
                            
                            /*
                            dispatch_async(dispatch_get_main_queue(), { 
                                 alertUpdate(window)
                            })
                           */
                        }
                        
                    }
                }
                else
                {
                   print("but appID not exist") 
                }
            }
        }
        if error != nil {
            print("connectionError == \(error)")
        }

    }
    dataTask.resume()
 
   /*
    let queue = NSOperationQueue.mainQueue()
    NSURLConnection.sendAsynchronousRequest(request, queue: queue) { (response, data, error) -> Void in
        if data != nil {
            print("itunes request Success")
            let dict = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves) as! NSDictionary
            
            if let resultsArr = dict!["results"] as? NSArray{
                if resultsArr.count>0{
                    if let infoDic = resultsArr[0] as? NSDictionary{
                        let latestVersion = infoDic.objectForKey("version") as! String
                        downLoadUrl = infoDic.objectForKey("trackViewUrl") as! String
                        
                        let latest = versionToInt(latestVersion)
                        let current = versionToInt(longBuildVersion)
                        
                        if latest >= current && latestVersion != longBuildVersion {
                            
                            alertUpdate(window)
                        }
                        
                    }
                }
                else
                {
                    print("but appID not exist")
                }
            }
        }
        if error != nil {
            print("connectionError == \(error)")
        }

    }
    */
}

private func alertUpdate(window : UIWindow){
    let alert: UIAlertController = UIAlertController(title:nil, message:"有新的版本更新",
        preferredStyle:UIAlertControllerStyle.alert)
    let saveAction = UIAlertAction(title: "确定", style: .default, handler:{
        (alerts: UIAlertAction!) -> Void in
       let url = NSURL(string: downLoadUrl)
        UIApplication.shared.openURL(url! as URL)
    })
    
    let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler:{
        (alerts: UIAlertAction!) -> Void in
        print("取消")
    })
    
    alert.addAction(saveAction)
    alert.addAction(cancelAction)
    
    window.rootViewController!.present(alert, animated: true, completion: nil)

}

private func versionToInt(str:String) ->Int{
    
    var tempStr = str as NSString
    
    tempStr = tempStr.replacingOccurrences(of: ".", with: "") as NSString
    if tempStr.length < 3 {
        tempStr = NSString(string: "\(tempStr)0")
        let tempInt = versionToInt(str: tempStr as String)
        tempStr = String(tempInt) as NSString
    }
    
    return tempStr.integerValue
}









