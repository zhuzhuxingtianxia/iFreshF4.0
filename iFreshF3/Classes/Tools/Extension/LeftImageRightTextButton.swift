//
//  LeftImageRightTextButton.swift
//  iFreshF
//
//  Created by Jion on 16/5/27.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class LeftImageRightTextButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont.systemFont(ofSize: 15)
        imageView?.contentMode = UIViewContentMode.center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView?.frame = CGRect(x:0, y:(height - (imageView?.size.height)!) * 0.5, width:(imageView?.size.width)!, height:(imageView?.size.height)!)
        titleLabel?.frame = CGRect(x:(imageView?.size.width)! + 10, y:0, width:width - (imageView?.size.width)! - 10, height:height)
    }

}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */
