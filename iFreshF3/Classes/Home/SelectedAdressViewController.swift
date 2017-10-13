//
//  SelectedAdressViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/13.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class SelectedAdressViewController: AnimationViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        buildNavigationItem()
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        navigationController?.navigationBar.barTintColor = LFBNavigationYellowColor
    }
    
    // MARK: - Build UI
    private func buildNavigationItem()
    {
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButton(title: "扫一扫", titleColor: UIColor.black, image: UIImage(named: "icon_black_scancode")!, hightLightImage: nil, target: self, action: #selector(SelectedAdressViewController.leftItemClick), type: ItemButtonType.Left)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton(title: "搜 索", titleColor: UIColor.black, image: UIImage(named: "icon_search")!, hightLightImage: nil, target: self, action: #selector(SelectedAdressViewController.rightItemClick), type: ItemButtonType.Right)
        
        let titleView = AdressTitleView(frame: CGRect(x:0, y:0, width:0, height:30))
        titleView.frame = CGRect(x:0, y:0, width:titleView.adressWidth, height:30)
        
        navigationItem.titleView = titleView
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SelectedAdressViewController.titleViewClick))
        navigationItem.titleView?.addGestureRecognizer(tap)
        
    }
    
    // MARK:- Action
    // MARK: 扫一扫和搜索Action
    @objc func leftItemClick() {
        let qrCode = QRCodeViewController()
        navigationController?.pushViewController(qrCode, animated: true)
    }
    @objc func rightItemClick() {
        let searchVC = SearchProductViewController()
        navigationController!.pushViewController(searchVC, animated: true)
    }
    @objc func titleViewClick(){
        let adressVC = MyAdressViewController { (adress) in
             weak var tmpSelf = self
            let titleView = AdressTitleView(frame: CGRect(x:0, y:0, width:0, height:30))
            titleView.setTitle(text: adress.address!)
            titleView.frame = CGRect(x:0, y:0, width:titleView.adressWidth, height:30)
            tmpSelf?.navigationItem.titleView = titleView
            UserInfo.sharedUserInfo.setDefaultAdress(adress: adress)
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(SelectedAdressViewController.titleViewClick))
            tmpSelf?.navigationItem.titleView?.addGestureRecognizer(tap)
        }
        adressVC.isSelectVC = true
        navigationController!.pushViewController(adressVC, animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
