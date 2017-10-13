//
//  ProgressHUDManager.swift
//  iFreshF
//
//  Created by Jion on 16/4/20.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit
import SVProgressHUD
class ProgressHUDManager {
    
    class func setBackgroundColor(color: UIColor) {
        SVProgressHUD.setBackgroundColor(color)
    }

    class func setForegroundColor(color: UIColor) {
        SVProgressHUD.setForegroundColor(color)
    }
    
    class func setSuccessImage(image: UIImage) {
        SVProgressHUD.setSuccessImage(image)
    }
    
    class func setErrorImage(image: UIImage) {
        SVProgressHUD.setErrorImage(image)
    }
    
    class func setFont(font: UIFont) {
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 16))
    }
    
    class func showImage(image: UIImage, status: String) {
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        SVProgressHUD.show(image, status: status)
    }
    
    class func show() {
        SVProgressHUD.show()
    }
    
    class func dismiss() {
        SVProgressHUD.dismiss()
    }
    
    class func showWithStatus(status: String) {
        SVProgressHUD.show(withStatus: status)
    }
    
    class func isVisible() -> Bool {
        return SVProgressHUD.isVisible()
    }
    
    class func showSuccessWithStatus(string: String) {
        SVProgressHUD.showSuccess(withStatus: string)
    }
    
    class func showErrorWithStatus(string: String) {
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        SVProgressHUD.showError(withStatus: string)
    }
    
    class func showErrorWithStatus(string: String,maskType:SVProgressHUDMaskType) {
        SVProgressHUD.showError(withStatus: string)
    }
}
