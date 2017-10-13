//
//  String+Extension.swift
//  iFreshF
//
//  Created by Jion on 16/4/14.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import Foundation
extension String {
    
    /// 清除字符串小数点末尾的0
    func cleanDecimalPointZero() -> String {
        
        let newStr = self as NSString
        var s = NSString()
        
        var offset = newStr.length - 1
        while offset > 0 {
            s = newStr.substring(with: NSMakeRange(offset, 1)) as NSString
            if s.isEqual(to: "0") || s.isEqual(to: ".") {
                offset -= 1
            } else {
                break
            }
        }
        
        return newStr.substring(to: offset + 1)
    }
    
    //清除字符串中的空字符
    mutating func cleanSpace() -> String{
        var newString = self as String
        newString = newString.replacingOccurrences(of: " ", with: "")
        self = newString
        return self
    }
}
