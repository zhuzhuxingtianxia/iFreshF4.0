//
//  LFBRefreshHeader.swift
//  iFreshF
//
//  Created by Jion on 16/5/16.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit
import MJRefresh

class LFBRefreshHeader: MJRefreshGifHeader {

    override func prepare() {
         super.prepare()
        
        stateLabel.isHidden = false
        lastUpdatedTimeLabel.isHidden = true
        
        setImages([UIImage(named: "v2_pullRefresh1")!], for: MJRefreshState.idle)
        setImages([UIImage(named: "v2_pullRefresh2")!], for: MJRefreshState.pulling)
        setImages([UIImage(named: "v2_pullRefresh1")!,UIImage(named: "v2_pullRefresh2")!], for: MJRefreshState.refreshing)
        
        setTitle("下拉刷新", for: MJRefreshState.idle)
        setTitle("松手开始刷新", for: MJRefreshState.pulling)
        setTitle("正在刷新", for: MJRefreshState.refreshing)
    }

}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */
