//
//  LFBSegmentedControl.swift
//  iFreshF
//
//  Created by Jion on 16/5/25.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class LFBSegmentedControl: UISegmentedControl {

    var segmentedClick:((_ index: Int) -> Void)?
    
    override init(items: [Any]?) {
        super.init(items: items)
        tintColor = LFBNavigationYellowColor
        setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: UIControlState.selected)
        setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.colorWithRGB(r: 100, g: 100, b: 100)], for: UIControlState.normal)
        addTarget(self, action: #selector(segmentedControlDidValuechange(sender:)), for: UIControlEvents.valueChanged)
        selectedSegmentIndex = 0
    }
    
    convenience init(items: [AnyObject]?, didSelectedIndex: @escaping (_ index: Int) -> ()) {
        self.init(items: items)
        
        segmentedClick = didSelectedIndex
    }
    //如果不重新父类初始化方法会崩溃
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @objc func segmentedControlDidValuechange(sender: UISegmentedControl) {
        if segmentedClick != nil {
            segmentedClick!(sender.selectedSegmentIndex)
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
