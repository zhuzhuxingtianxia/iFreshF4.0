//
//  MyShopViewController.swift
//  iFreshF
//
//  Created by Jion on 16/5/30.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class MyShopViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "我的店铺"
        let imageView = UIImageView(image: UIImage(named: "v2_store_empty"))
        imageView.center = CGPoint(x:view.center.x, y:view.center.y - 150)
        view.addSubview(imageView)
        
        let titleLabel = UILabel(frame: CGRect(x:0,y:imageView.frame.maxY + 10,width:view.width, height:30))
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.text = "还没有收藏的店铺呦~"
        view.addSubview(titleLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
