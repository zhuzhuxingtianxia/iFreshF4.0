//
//  WebViewController.swift
//  iFreshF
//
//  Created by Jion on 16/5/5.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController {

    private var webView = UIWebView(frame: ZJScreenBounds)
    private var urlStr: String?
    let loadPregessAnimationView: LoadProgressAnimationView = LoadProgressAnimationView(frame: CGRect(x:0,y:0,width:ZJScreenWidth,height:3))
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        view.addSubview(webView)
        view.addSubview(loadPregessAnimationView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(navtigationTitle: String, urlStr: String) {
        self.init(nibName: nil, bundle: nil)
        navigationItem.title = navtigationTitle
       self.urlStr = urlStr
        webView.loadRequest(NSURLRequest(url: NSURL(string: urlStr)! as URL) as URLRequest)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildRightItemBarButton()

        view.backgroundColor = UIColor.colorWithRGB(r: 230, g: 230, b: 230)
        webView.backgroundColor = UIColor.colorWithRGB(r: 230, g: 230, b: 230)
        webView.delegate = self
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: false)
        //改变导航条的颜色
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
    }
    
    //MARK: - Action
    override func refreshClick() {
        if urlStr != nil && (urlStr?.characters.count)! > 1 {
             webView.loadRequest(NSURLRequest(url: NSURL(string: urlStr!)! as URL) as URLRequest)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
}

extension WebViewController: UIWebViewDelegate {
    //开始加载
    func webViewDidStartLoad(_ webView: UIWebView){
        loadPregessAnimationView.startLoadPreogressAnimation()
    }
    //加载完成
   func  webViewDidFinishLoad(_ webView: UIWebView) {
    loadPregessAnimationView.endLoadPreogressAnimation()
    }
    //加载失败
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        loadPregessAnimationView.endLoadPreogressAnimation()
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

