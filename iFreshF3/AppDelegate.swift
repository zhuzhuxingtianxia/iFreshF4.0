//
//  AppDelegate.swift
//  iFreshF3
//
//  Created by Jion on 2017/3/9.
//  Copyright © 2017年 Youjuke. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setAppSubject()
        
        buildKeyWindow()
        addNotification()
        
        return true
    }
    
    //MARK:---添加通知
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.showMainTabbarControllerSucess(noti:)), name: NSNotification.Name(rawValue:ADImageLoadSecussed), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.showMainTabbarControllerFale), name: NSNotification.Name(rawValue:ADImageLoadFail), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.showMainTabBarController), name: NSNotification.Name(rawValue: GuideViewControllerDidFinish), object: nil)
        
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    //MARK:--显示界面
    private func buildKeyWindow(){
        window = UIWindow(frame: ZJScreenBounds)
        window!.makeKeyAndVisible()
        
        let isFristOpen = UserDefaults.standard.object(forKey: "isFristOpenApp")
        if isFristOpen == nil {
            window?.rootViewController = GuideViewController()
            UserDefaults.standard.set("isFristOpenApp", forKey: "isFristOpenApp")
            
        }else{
            
            loadADRootViewController()
        }
        
    }
    
    private func loadADRootViewController(){
        let adViewController = ADViewController()
        let navAd = UINavigationController(rootViewController: adViewController)
        weak var tmpSelf = self
        
        MainAD.loadADData { (data, error) -> Void in
            if data?.data?.img_name != nil {
                adViewController.imageName = data!.data!.img_name
                tmpSelf!.window?.rootViewController = navAd
            }
        }
    }
    
    // MARK: - Action
    @objc func showMainTabbarControllerSucess(noti: NSNotification) {
        let adImage = noti.object as? UIImage
        let mainTabBar = MainTabBarController()
        mainTabBar.adImage = adImage
        window?.rootViewController = mainTabBar
    }
    
    @objc func showMainTabBarController() {
        window!.rootViewController = MainTabBarController()
    }
    @objc func showMainTabbarControllerFale() {
        window!.rootViewController = MainTabBarController()
    }
    
    //MARK:--设置主题
    private func setAppSubject(){
        
        /*
         //在info.plist文件中加入一对键值
         Status bar is initially hidden 设置是否在启动的时候显示状态栏
         View controller-based status bar appearance 是否显示控制器的状态栏
         */
        
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.backgroundColor = UIColor.white
        tabBarAppearance.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        let navBarnAppearance = UINavigationBar.appearance()
        navBarnAppearance.isTranslucent = false
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

