//
//  ADDetailController.swift
//  iFreshF
//
//  Created by Jion on 16/4/21.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class ADDetailController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buildNavigationItem()
    }
    
    // MARK: - Build UI
    private func buildNavigationItem() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.title = "广告详情"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButton(image: UIImage(named: "v2_goback")!, target: self, action: #selector(ADDetailController.leftNavigitonItemClick))
    }
    
    // MARK: -  Action
    @objc func leftNavigitonItemClick() {
        
    _ = navigationController?.popViewController(animated: true)
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
