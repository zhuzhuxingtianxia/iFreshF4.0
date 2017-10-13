//
//  HotView.swift
//  iFreshF
//
//  Created by Jion on 16/5/4.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class HotView: UIView {

    private let iconW = (ZJScreenWidth - 2 * HotViewMargin) * 0.25
    private let iconH: CGFloat = 80
    
    var iconClick:((_ index: Int) -> ())?
    
    //rows数量
    private var rows: Int = 0 {
        willSet {
            bounds = CGRect(x:0, y:0, width:ZJScreenWidth, height:iconH * CGFloat(newValue))
        }
    }
    
    // MARK: 模型的Set方法
    var headData: HeadData? {
        didSet {
            if (headData?.icons?.count)! > 0 {
                if headData!.icons!.count % 4 != 0 {
                    self.rows = headData!.icons!.count / 4 + 1
                }else{
                    self.rows = headData!.icons!.count / 4
                }
                var iconX:CGFloat = 0
                var iconY:CGFloat = 0
                for i in 0..<headData!.icons!.count {
                    
                    iconX = CGFloat(i % 4) * iconW + HotViewMargin
                    iconY = iconH * CGFloat(i / 4)
                    let icon = IconImageTextView(frame: CGRect(x:iconX, y:iconY, width:iconW, height:iconH), placeholderImage: UIImage(named: "icon_icons_holder")!)
                    icon.tag = i
                    icon.activitie = headData!.icons![i]
                    let tap = UITapGestureRecognizer(target: self, action: #selector(HotView.iconClick(tap:)))
                    icon.addGestureRecognizer(tap)
                    addSubview(icon)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect,iconClick: @escaping ((_ index: Int) -> Void)) {
        self.init(frame:frame)
        self.iconClick = iconClick
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Action
    @objc func iconClick(tap: UITapGestureRecognizer) {
        if iconClick != nil {
            iconClick!(tap.view!.tag)
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
