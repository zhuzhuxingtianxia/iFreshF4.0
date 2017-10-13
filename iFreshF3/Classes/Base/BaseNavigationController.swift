//
//  BaseNavigationController.swift
//  iFreshF
//
//  Created by Jion on 16/4/13.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
      var isAnimation = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //这句实现侧滑返回，注释则没有这个效果
        interactivePopGestureRecognizer!.delegate = nil
    }

    lazy var backBtn: UIButton = {
        //设置返回按钮属性
        let backBtn = UIButton(type: UIButtonType.custom)
        backBtn.setImage(UIImage(named: "v2_goback"), for: .normal)
        backBtn.titleLabel?.isHidden = true
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0)
        let btnW: CGFloat = ZJScreenWidth > 375.0 ? 50 : 44
        backBtn.frame = CGRect(x:0, y:0, width:btnW, height:40)
        
        return backBtn
    }()
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.navigationItem.hidesBackButton = true
        if childViewControllers.count > 0 {
            
            UINavigationBar.appearance().backItem?.hidesBackButton = false
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            
            viewController.hidesBottomBarWhenPushed = true
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc func backBtnClick() {
        popViewController(animated: isAnimation)
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
