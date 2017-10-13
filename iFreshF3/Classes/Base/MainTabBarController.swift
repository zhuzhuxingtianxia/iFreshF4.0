//
//  MainTabBarController.swift
//  iFreshF
//
//  Created by Jion on 16/4/12.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class MainTabBarController: AnimationTabBarController,UITabBarControllerDelegate {

    private var fristLoadMainTabbarController:Bool = true
    private var adImageView:UIImageView?
    
    var adImage:UIImage?{
        didSet{
            weak var tempSelf = self
            adImageView = UIImageView(frame: ZJScreenBounds)
            adImageView!.image = adImage!
            self.view.addSubview(adImageView!)
            
            UIImageView.animate(withDuration: 2.0, animations: {
                tempSelf!.adImageView!.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                tempSelf!.adImageView!.alpha = 0
                
                }) { (finish) in
                    tempSelf!.adImageView!.removeFromSuperview()
                    tempSelf!.adImageView = nil
                    
            }
        }
    }
  
// MARK:- view life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        // Do any additional setup after loading the view.
        delegate = self
        buildMainTabBarChildViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if fristLoadMainTabbarController {
            //使用自定义tabbar  viewDidLoad中使用的是系统的
            let containers = createViewContainers()
            createCustomIcons(containers: containers)
            
            fristLoadMainTabbarController = false
        }
    }

// MARK: - Method
    // MARK: 初始化tabbar
    private func buildMainTabBarChildViewController(){
        tabBarControllerAddChildController(childController: HomeViewController(), title: "首页", imageName: "v2_home", selectedImageName: "v2_home_r",tag: 0)
        
        tabBarControllerAddChildController(childController: SupermarketViewController(), title: "闪电超市", imageName: "v2_order", selectedImageName: "v2_order_r", tag: 1)
        tabBarControllerAddChildController(childController: ShopCartViewController(), title: "购物车", imageName: "shopCart", selectedImageName: "shopCart", tag: 2)
        tabBarControllerAddChildController(childController: MineViewController(), title: "我的", imageName: "v2_my", selectedImageName: "v2_my_r", tag: 3)
        
    }
    
    private func tabBarControllerAddChildController(childController:UIViewController,title: String, imageName: String,selectedImageName: String ,tag: Int){
        
//        let vcItem = RAMAnimatedTabBarItem(title: title, image: UIImage(named: imageName)?.imageWithRenderingMode(.AlwaysOriginal), selectedImage: UIImage(named: selectedImageName)?.imageWithRenderingMode(.AlwaysOriginal))
//        vcItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orangeColor()], forState: UIControlState.Selected)
        
        let vcItem = RAMAnimatedTabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
        vcItem.tag = tag
        vcItem.animation = RAMBounceAnimation()
        childController.tabBarItem = vcItem
        let navigationVC = BaseNavigationController(rootViewController: childController)
        addChildViewController(navigationVC)
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 // MARK: -TabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let childArr = tabBarController.childViewControllers as NSArray
        let index = childArr.index(of: viewController)
        if index == 2 {
            return false
        }
        
        return true

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
