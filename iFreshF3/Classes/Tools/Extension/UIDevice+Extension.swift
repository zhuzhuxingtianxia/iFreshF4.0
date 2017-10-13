//
//  UIDevice+Extension.swift
//  iFreshF
//
//  Created by Jion on 16/4/13.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

extension UIDevice {
    
    class func currentDeviceScreenMeasurement() -> CGFloat {
        var deviceScree: CGFloat = 3.5
        
        if ((568 == ZJScreenHeight && 320 == ZJScreenWidth) || (1136 == ZJScreenHeight && 640 == ZJScreenWidth)) {
            deviceScree = 4.0;
        } else if ((667 == ZJScreenHeight && 375 == ZJScreenWidth) || (1334 == ZJScreenHeight && 750 == ZJScreenWidth)) {
            deviceScree = 4.7;
        } else if ((736 == ZJScreenHeight && 414 == ZJScreenWidth) || (2208 == ZJScreenHeight && 1242 == ZJScreenWidth)) {
            deviceScree = 5.5;
        }
        
        return deviceScree
    }
}