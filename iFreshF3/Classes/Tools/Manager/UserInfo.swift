//
//  UserInfo.swift
//  iFreshF
//
//  Created by Jion on 16/4/18.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class UserInfo: NSObject {

    private static let instance = UserInfo()

    private var allAdress: [Adress]?
    
    var isLogin: Bool?
    
    class var sharedUserInfo: UserInfo {
        
        return instance
    }
    
    func hasDefaultAdress() -> Bool {
        
        if allAdress != nil {
            return true
        } else {
            return false
        }
    }
    
    func defaultAdress() -> Adress?{
        if allAdress == nil{
           weak var tmpSelf = self
            
            AdressData.loadMyAdressData(completion: { (data, error) in
                if (data?.data?.count)! > 0 {
                    tmpSelf?.allAdress = data!.data!
                }else{
                    tmpSelf?.allAdress?.removeAll()
                }
            })
            
            return (allAdress?.count)! > 1 ? allAdress![0] : nil
        }else{

            return allAdress![0]
        }
        
    }
    func setDefaultAdress(adress: Adress) {
        if allAdress != nil {
            allAdress?.insert(adress, at: 0)
        } else {
            allAdress = [Adress]()
            allAdress?.append(adress)
        }
    }

    func setAllAdress(adresses: [Adress]){
        allAdress = adresses
    }
    func cleanAllAdress(){
        allAdress = nil
    }
    
    
}
