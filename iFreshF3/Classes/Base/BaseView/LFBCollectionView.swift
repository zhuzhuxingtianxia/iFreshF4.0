//
//  LFBCollectionView.swift
//  iFreshF
//
//  Created by Jion on 16/4/21.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class LFBCollectionView: UICollectionView {

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        delaysContentTouches = false
        canCancelContentTouches = true
        
        let wrapView = subviews.first
        
        if wrapView != nil && NSStringFromClass((wrapView?.classForCoder)!).hasPrefix("WrapperView") {
            for gesture in wrapView!.gestureRecognizers! {
                if NSStringFromClass(gesture.classForCoder).components(separatedBy: "DelayedTouchesBegan").count>0 {
                    gesture.isEnabled = false
                    break
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view.isKind(of:UIControl.self) {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }
    

}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */
