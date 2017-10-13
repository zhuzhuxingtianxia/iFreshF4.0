//
//  LFBActionSheet.swift
//  iFreshF
//
//  Created by Jion on 16/4/20.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

enum ShareType: Int {
    case WeiXinMyFriend = 1
    case WeiXinCircleOfFriends = 2
    case SinaWeiBo = 3
    case QQZone = 4
    case QQFriend = 5
}

class LFBActionSheet: NSObject {

    var selectedShaerType: ((_ shareType: ShareType) -> ())?
    private var actionSheet: UIActionSheet?
    
    func showActionSheetViewShowInView(inView: UIView, selectedShareType:@escaping ((_ ShareType: ShareType) -> ())) {
        actionSheet = UIActionSheet(title: "分享到", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "微信好友", "微信朋友圈", "新浪微博", "QQ空间")
        self.selectedShaerType = selectedShareType
        actionSheet?.show(in: inView)
    }
}

extension LFBActionSheet:UIActionSheetDelegate{
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        print(buttonIndex)
        if selectedShaerType != nil {
            switch buttonIndex {
            case ShareType.WeiXinMyFriend.rawValue:
                selectedShaerType!(.WeiXinMyFriend)
                
            case ShareType.WeiXinCircleOfFriends.rawValue:
                selectedShaerType!(.WeiXinCircleOfFriends)
                
            case ShareType.SinaWeiBo.rawValue:
                selectedShaerType!(.SinaWeiBo)
                
            case ShareType.QQZone.rawValue:
                selectedShaerType!(.QQZone)
                
            default:
                break
            }
        }
    }
}








//end
