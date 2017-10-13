//
//  Const.swift
//  iFreshF
//
//  Created by Jion on 16/4/11.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

// MARK: - 全局常用属性
public let statusBarH:CGFloat = UIApplication.shared.statusBarFrame.height
public func NavigationH(vc:UIViewController?) -> CGFloat {
    guard let weakVC = vc else {
        return statusBarH + 44
    }
    guard let nav = weakVC.navigationController else {
        return statusBarH + 44
    }
    
    return statusBarH + nav.navigationBar.frame.height
}
public let Navigation:CGFloat = statusBarH + 44
public let safeAreaBottomH:CGFloat = statusBarH > 20 ? 34 : 0

public let ZJScreenWidth:CGFloat = UIScreen.main.bounds.size.width
public let ZJScreenHeight:CGFloat = UIScreen.main.bounds.size.height
public let ZJScreenBounds: CGRect = UIScreen.main.bounds
public let ShopCarRedDotAnimationDuration: TimeInterval = 0.2
public let LFBNavigationBarWhiteBackgroundColor = UIColor.colorWithRGB(r: 249, g: 250, b: 253)

// MARK: - Home 属性
public let HotViewMargin: CGFloat = 10
public let HomeCollectionViewCellMargin: CGFloat = 10
public let HomeCollectionTextFont = UIFont.systemFont(ofSize: 14)
public let HomeCollectionCellAnimationDuration: TimeInterval = 1.0
// MARK: - 通知
/// 首页headView高度改变
public let HomeTableHeadViewHeightDidChange = "HomeTableHeadViewHeightDidChange"
/// 首页商品库存不足
public let HomeGoodsInventoryProblem = "HomeGoodsInventoryProblem"

public let GuideViewControllerDidFinish = "GuideViewControllerDidFinish"
// MARK: - 广告页通知
public let ADImageLoadSecussed = "ADImageLoadSecussed"
public let ADImageLoadFail = "ADImageLoadFail"


// MARK: - Mine属性
public let CouponViewControllerMargin: CGFloat = 20

// MARK: - Cache路径
public let LFBCachePath: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!

// MARK: - AuthorURL
public let GitHubURLString: String = "https://github.com"
public let SinaWeiBoURLString: String = "http://weibo.com"
public let BlogURLString: String = "http://www.jianshu.com"

// MARK: - 常用颜色
public let LFBGlobalBackgroundColor = UIColor.colorWithRGB(r: 239, g: 239, b: 239)
public let LFBNavigationYellowColor = UIColor.colorWithRGB(r: 253, g: 212, b: 49)
public let LFBTextGreyColol = UIColor.colorWithRGB(r: 130, g: 130, b: 130)
public let LFBTextBlackColor = UIColor.colorWithRGB(r: 50, g: 50, b: 50)

// MARK: - 购物车管理工具通知
public let LFBShopCarDidRemoveProductNSNotification = "LFBShopCarDidRemoveProductNSNotification"
/// 购买商品数量发生改变
public let LFBShopCarBuyProductNumberDidChangeNotification = "LFBShopCarBuyProductNumberDidChangeNotification"
/// 购物车商品价格发送改变
public let LFBShopCarBuyPriceDidChangeNotification = "LFBShopCarBuyPriceDidChangeNotification"
// MARK: - 购物车ViewController
public let ShopCartRowHeight: CGFloat = 50

// MARK: - 搜索ViewController
public let LFBSearchViewControllerHistorySearchArray = "LFBSearchViewControllerHistorySearchArray"





//end
