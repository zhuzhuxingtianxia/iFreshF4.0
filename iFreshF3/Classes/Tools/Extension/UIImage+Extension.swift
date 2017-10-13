//
//  UIImage+Extension.swift
//  iFreshF
//
//  Created by Jion on 16/4/14.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit
extension UIImage {
    
    class func imageWithColor(color: UIColor, size: CGSize, alpha: CGFloat) -> UIImage {
        let rect = CGRect(x:0, y:0, width:size.width, height:size.height)
        
        UIGraphicsBeginImageContext(rect.size)
        let ref = UIGraphicsGetCurrentContext()
        ref!.setAlpha(alpha)
        ref!.setFillColor(color.cgColor)
        ref!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
    
    class func createImageFromView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContext(view.bounds.size);
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return image!
    }
    
    //将image修剪成圆形
    func imageClipOvalImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0)
        let ctx = UIGraphicsGetCurrentContext()
        let rect = CGRect(x:0, y:0, width:self.size.width, height:self.size.height)
        ctx!.addEllipse(in: rect)
        
        ctx!.clip()
        self.draw(in: rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
