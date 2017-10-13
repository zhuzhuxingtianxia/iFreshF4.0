//
//  UIColor+Extension.swift
//  iFreshF
//
//  Created by Jion on 16/4/11.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import Foundation
import UIKit
extension UIColor{
    
    //MARK:---使用字符串
    class func colorHexString(hexString: String) ->UIColor {
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        //删除字符串中的空格，并转化成大写
        var hexColorString = hexString.trimmingCharacters(in: CharacterSet.whitespaces).uppercased()
        //var hexColorString = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()).uppercaseString;
        
        if hexColorString.hasPrefix("0X") {
            //hexColorString = hexColorString.stringByReplacingOccurrencesOfString("0X", withString: "#")
            hexColorString = hexColorString.replacingOccurrences(of: "0X", with: "#")
        }
        
        if !hexColorString.hasPrefix("#"){
            hexColorString = "#"+hexColorString;
        }
        
        //let index   = hexColorString.startIndex.advancedBy(1)
        let index   = hexColorString.startIndex
        let hex     = hexColorString.substring(from: index)
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.characters.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
            }
        } else {
            print("Scan hex error")
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

   //MARK:--使用RGB
    class func colorWithRGB(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor{
        
      return  UIColor.colorWithRGBA(r: r, g: g, b: b, a: 1.0)
    }
    
    class func randomColor() -> UIColor {
        let r = CGFloat(arc4random_uniform(256))
        let g = CGFloat(arc4random_uniform(256))
        let b = CGFloat(arc4random_uniform(256))
        return UIColor.colorWithRGB(r: r, g: g, b: b)
    }
    
    class func colorWithRGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor
    {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
