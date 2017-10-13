//
//  ADViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/11.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class ADViewController: UIViewController {

    var adImage:UIImage? = nil
    private lazy var backImageView:UIImageView = {
        let backImageView = UIImageView()
        backImageView.frame = ZJScreenBounds
        backImageView.backgroundColor = UIColor.orange
        backImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(ADViewController.tapAction))
        backImageView.addGestureRecognizer(tap)
        return backImageView
        
    }()
    var imageName: String? {
        
        didSet {
            var placeholderImageName: String?
            switch UIDevice.currentDeviceScreenMeasurement() {
            case 3.5:
                placeholderImageName = "iphone4"
            case 4.0:
                placeholderImageName = "iphone5"
            case 4.7:
                placeholderImageName = "iphone6"
            default:
                placeholderImageName = "iphone6s"
            }
            
            //sdwebimg新用法
            backImageView.sd_setImage(with: URL(string: imageName!), placeholderImage: UIImage(named: placeholderImageName!), options: [.continueInBackground, .lowPriority], completed:  {
                (image: UIImage?, error: Error?, _, imageURL: URL?) in
                
                if error != nil {
                    //加载广告失败
                    print("加载广告失败")
                    NotificationCenter.default.post(name:Notification.Name(ADImageLoadFail), object: nil)
                }
                
                if image != nil {
                    self.adImage = image
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: { 
                        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.fade)
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {

                            NotificationCenter.default.post(name:Notification.Name(ADImageLoadSecussed), object: image)
                        })
                    })
                    
                }else{
                    
                    //加载广告失败
                    print("加载广告失败")
                    NotificationCenter.default.post(name:Notification.Name(ADImageLoadFail), object: nil)
                    
                }

            })
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = true
        view.addSubview(backImageView)
        UIApplication.shared.setStatusBarHidden(true, with: UIStatusBarAnimation.none)
    }
    
    @objc func tapAction() {
        print("点击广告")
//        navigationController?.pushViewController(ADDetailController(), animated: true)
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
