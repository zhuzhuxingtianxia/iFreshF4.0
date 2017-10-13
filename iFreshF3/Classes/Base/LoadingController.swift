//
//  LoadingController.swift
//  iFreshF
//
//  Created by Jion on 16/4/11.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class LoadingController: UIViewController {
    var window:UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        window = (UIApplication.shared.delegate as! AppDelegate).window

    self.perform(#selector(LoadingController.goMain), with: nil, afterDelay: 0.5)
        // Do any additional setup after loading the view.
    }

    @objc func goMain(){
       addNotification()
       buildKeyWindow()
    }
    
    //MARK:---添加通知
    /*
     添加通知出问题，本类在转化根视图的时候通知不响应。
     
     */
   private func addNotification() {
    NotificationCenter.default.addObserver(self, selector: #selector(LoadingController.showMainTabbarControllerSucess(noti:)), name: NSNotification.Name(rawValue: ADImageLoadSecussed), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(LoadingController.showMainTabbarControllerFale), name: NSNotification.Name(rawValue: ADImageLoadFail), object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(LoadingController.showMainTabBarController), name: NSNotification.Name(rawValue: GuideViewControllerDidFinish), object: nil)
    
    }
    
    //MARK:--显示界面
    private func buildKeyWindow(){
     let isFristOpen = UserDefaults.standard.object(forKey: "isFristOpenApp")
        if isFristOpen == nil {
            self.present(GuideViewController(), animated: false, completion: {
                
            })
            
            UserDefaults.standard.set("isFristOpenApp", forKey: "isFristOpenApp")
            
        }else{
            
            loadADRootViewController()
        }
        
    }
    
   private func loadADRootViewController(){
    
    let adViewController = ADViewController()
    weak var tmpSelf = self
    MainAD.loadADData { (data, error) in
        if data?.data?.img_name != nil{
          adViewController.imageName = data?.data?.img_name
            tmpSelf?.window?.rootViewController = adViewController
        }
      }
    }
    
    //MARK:--Action
    @objc func showMainTabBarController() {
        
        window!.rootViewController = MainTabBarController()
    }
    @objc func showMainTabbarControllerFale() {
        window!.rootViewController = MainTabBarController()
    }
    @objc func showMainTabbarControllerSucess(noti: NSNotification) {
        let adImage = noti.object as!  UIImage
        let mainTabBar = MainTabBarController()
        mainTabBar.adImage = adImage
        window?.rootViewController = mainTabBar
    }
    //不能移除通知，否则点击事件不响应
        deinit{
            NotificationCenter.default.removeObserver(self)
        }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
