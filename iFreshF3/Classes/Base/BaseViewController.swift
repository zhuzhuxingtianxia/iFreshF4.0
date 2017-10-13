//
//  BaseViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/11.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
        view.backgroundColor = LFBGlobalBackgroundColor
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buildRightItemBarButton() {
        let rightButton = UIButton(frame: CGRect(x:0, y:0, width:60, height:44))
        rightButton.setImage(UIImage(named: "v2_refresh"), for: UIControlState.normal)
        rightButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -53)
        rightButton.addTarget(self, action: #selector(BaseViewController.refreshClick), for: UIControlEvents.touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    // MARK: - Action
    @objc func refreshClick() {
       
    }


}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */
