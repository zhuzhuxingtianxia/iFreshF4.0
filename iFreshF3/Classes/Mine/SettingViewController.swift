//
//  SettingViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/20.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController {

    private let subViewHeight: CGFloat = 50
    
    private var aboutMeView: UIView!
    private var cleanCacheView: UIView!
    private var cacheNumberLabel: UILabel!
    private var logoutView: UIView!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        buildaboutMeView()
        buildCleanCacheView()
        buildLogoutView()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       navigationItem.title = "设置"
    }
    
    // MARK: - Build UI
    private func buildaboutMeView() {
        aboutMeView = UIView(frame: CGRect(x:0, y:10, width:ZJScreenWidth, height:subViewHeight))
        aboutMeView.backgroundColor = UIColor.white
        view.addSubview(aboutMeView!)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.aboutMeViewClick))
        aboutMeView.addGestureRecognizer(tap)
        
        let aboutLabel = UILabel(frame: CGRect(x:20, y:0, width:200, height:subViewHeight))
        aboutLabel.text = "关于猪猪行天下"
        aboutLabel.font = UIFont.systemFont(ofSize: 16)
        aboutMeView.addSubview(aboutLabel)
        
        let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
        arrowImageView.frame = CGRect(x:ZJScreenWidth - 20, y:(subViewHeight - 10) * 0.5, width:5, height:10)
        aboutMeView.addSubview(arrowImageView)
    }
    
    private func buildCleanCacheView() {
        cleanCacheView = UIView(frame: CGRect(x:0,y: subViewHeight + 10, width:ZJScreenWidth, height:subViewHeight))
        cleanCacheView.backgroundColor = UIColor.white
        view.addSubview(cleanCacheView!)
        
        let cleanCacheLabel = UILabel(frame: CGRect(x:20, y:0, width:200, height:subViewHeight))
        cleanCacheLabel.text = "清理缓存"
        cleanCacheLabel.font = UIFont.systemFont(ofSize: 16)
        cleanCacheView.addSubview(cleanCacheLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.cleanCacheViewClick))
        cleanCacheView.addGestureRecognizer(tap)
        
        cacheNumberLabel = UILabel(frame: CGRect(x:150, y:0, width:ZJScreenWidth - 165, height:subViewHeight))
        cacheNumberLabel.textAlignment = NSTextAlignment.right
        cacheNumberLabel.textColor = UIColor.colorWithRGB(r: 180, g: 180, b: 180)
        cacheNumberLabel.text = String().appendingFormat("%.2fM", FileTool.folderSize(path: LFBCachePath)).cleanDecimalPointZero()
        cleanCacheView.addSubview(cacheNumberLabel)
        
        let lineView = UIView(frame: CGRect(x:10, y:-0.5, width:ZJScreenWidth - 10, height:0.5))
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.08
        cleanCacheView.addSubview(lineView)
    }

    private func buildLogoutView() {
        logoutView = UIView(frame: CGRect(x:0, y:cleanCacheView.frame.maxY + 20, width:ZJScreenHeight, height:subViewHeight))
        logoutView.backgroundColor = UIColor.white
        view.addSubview(logoutView)
        
        let logoutLabel = UILabel(frame: CGRect(x:0, y:0, width:ZJScreenWidth, height:subViewHeight))
        logoutLabel.text = "退出当前账号"
        logoutLabel.textColor = UIColor.colorWithRGB(r: 60, g: 60, b: 60)
        logoutLabel.font = UIFont.systemFont(ofSize: 15)
        logoutLabel.textAlignment = NSTextAlignment.center
        logoutView.addSubview(logoutLabel)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SettingViewController.logoutViewClick))
        logoutView.addGestureRecognizer(tap)
        
        if UserInfo.sharedUserInfo.isLogin == false {
            logoutView.isHidden = true
        }
    }

    // MARK: - Action
    @objc func aboutMeViewClick() {
        let aboutVc = AboutViewController()
        navigationController?.pushViewController(aboutVc, animated: true)
    }
    
    @objc func cleanCacheViewClick() {
        weak var tmpSelf = self
        ProgressHUDManager.show()
        FileTool.cleanFolder(path: LFBCachePath) { () -> () in
            tmpSelf!.cacheNumberLabel.text = "0M"
            ProgressHUDManager.dismiss()
        }
    }
    
    @objc func logoutViewClick() {
      UserInfo.sharedUserInfo.isLogin = false
    NotificationCenter.default.post(name:NSNotification.Name(rawValue: "headerIcon"), object: nil)
        
       _ = navigationController?.popViewController(animated: true)
        
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

