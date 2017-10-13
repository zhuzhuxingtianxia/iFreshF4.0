//
//  ShareManager.swift
//  iFreshF
//
//  Created by Jion on 16/5/6.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class ShareManager: NSObject {

    class func shareToShareType(shareType: ShareType ,shareModel:Goods ,vc: UIViewController) {
        let message:String;
        switch shareType {
        case .WeiXinMyFriend:
             message = "微信分享";
            print("微信分享");
            break
            
        case .WeiXinCircleOfFriends:
            message = "微信朋友圈分享";
            print("微信朋友圈分享");
            break
            
        case .SinaWeiBo:
            message = "新浪微博分享";
             print("新浪微博分享");
            break
            
        case .QQZone:
            message = "QQ分享";
            print("QQ分享");
            break
           
        default:
            message = "其他分享";

             print("其他分享");
            break
            
        }
        
        let alert = UIAlertView(title: "分享", message: message, delegate: nil, cancelButtonTitle: "好的")
        alert.show()
    }
    
    class func showSuccessAlert() {
        
        let alert = UIAlertView(title: "成功", message: "分享成功", delegate: nil, cancelButtonTitle: "知道了")
        alert.show()
    }
    
    class func showErrorAlert() {
        
        let alert = UIAlertView(title: "失败", message: "分享失败", delegate: nil, cancelButtonTitle: "知道了")
        alert.show()
        
    }
}
