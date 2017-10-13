//
//  LoadProgressAnimationView.swift
//  iFreshF
//
//  Created by Jion on 16/5/6.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class LoadProgressAnimationView: UIView {

    var viewWidth: CGFloat = 0
    override var frame: CGRect {
        willSet {
            if frame.size.width == viewWidth {
                self.isHidden = true
            }
            super.frame = frame
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        viewWidth = frame.size.width
        backgroundColor = LFBNavigationYellowColor
        self.frame.size.width = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoadPreogressAnimation() {
        self.frame.size.width = 0
        isHidden = false
        weak var tmpSelf = self
        UIView.animate(withDuration: 0.4, animations: { 
            tmpSelf!.frame.size.width = tmpSelf!.viewWidth * 0.6
            
            }) { (finish) in
               
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                    UIView.animate(withDuration: 0.3, animations: {
                        tmpSelf!.frame.size.width = tmpSelf!.viewWidth * 0.8
                    })
                })
                
        }
    }
    
    func endLoadPreogressAnimation() {
         weak var tmpSelf = self
        
        UIView.animate(withDuration: 0.2, animations: { 
            tmpSelf!.frame.size.width = tmpSelf!.viewWidth
            }) { (finish) in
                tmpSelf!.isHidden = true
        }
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */

