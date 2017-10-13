//
//  HomeTableHeadView.swift
//  iFreshF
//
//  Created by Jion on 16/5/4.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

/*
 swift在设置代理的时候，默认是必选实现，
  要设置可选实现optional,要在声明代理时使用关键字@objc
 */
// - MARK: Delegate
 @objc protocol HomeTableHeadViewDelegate: NSObjectProtocol {
   @objc optional func tabelheadView(headView: HomeTableHeadView, focusImageViewClick index: Int)
    
  @objc optional func tableHeadView(headView: HomeTableHeadView, iconClick index: Int)
}

class HomeTableHeadView: UIView {

    private var pageScrollView: PageScrollView?
    private var hotView: HotView?
    weak var delegate: HomeTableHeadViewDelegate?
    
    var tableHeadViewHeight: CGFloat = 0 {
        willSet {
            //发通知改变headView的高度
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: HomeTableHeadViewHeightDidChange), object: newValue)
            frame = CGRect(x:0, y:-newValue, width:ZJScreenWidth, height:newValue)
        }
    }
    
    // MARK: 模型的set方法
    var headData:HeadResources? {
        didSet {
            pageScrollView?.headData = headData
            hotView!.headData = headData?.data
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildPageScrollView()
        buildHotView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: 初始化子控件
    func buildPageScrollView() {
        weak var tmpSelf = self
        pageScrollView = PageScrollView(frame: CGRect.zero, placeholder: UIImage(named: "v2_placeholder_full_size")!, focusImageViewClick: { (index) in
            
            if tmpSelf!.delegate != nil && (tmpSelf?.delegate?.responds(to: #selector(HomeTableHeadViewDelegate.tabelheadView(headView:focusImageViewClick:)))) != nil {
                
                tmpSelf!.delegate!.tabelheadView!(headView: tmpSelf!, focusImageViewClick: index)
            }
        })
        pageScrollView?.isCycle = true
        addSubview(pageScrollView!)
    }
    func buildHotView() {
        weak var tmpSelf = self
        hotView = HotView(frame: CGRect.zero, iconClick: { (index) in
            
            if ((tmpSelf!.delegate?.responds(to: #selector(HomeTableHeadViewDelegate.tableHeadView(headView:iconClick:)))) != nil) {
                
                tmpSelf!.delegate!.tableHeadView!(headView: tmpSelf!, iconClick: index)
            }
        })
        hotView?.backgroundColor = UIColor.white
        addSubview(hotView!)
    }
    
    //MARK: 布局子控件
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pageScrollView?.frame = CGRect(x:0, y:0, width:ZJScreenWidth, height:ZJScreenWidth * 0.31)
        
        hotView?.frame.origin = CGPoint(x:0, y:(pageScrollView?.frame)!.maxY)
        
        tableHeadViewHeight = hotView!.frame.maxY
    }

}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */
