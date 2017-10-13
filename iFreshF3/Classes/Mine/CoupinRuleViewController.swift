//
//  CoupinRuleViewController.swift
//  iFreshF
//
//  Created by Jion on 16/5/26.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class CoupinRuleViewController: BaseViewController {

    private let webView = UIWebView(frame: CGRect(x:0, y:0, width:ZJScreenWidth, height:ZJScreenHeight - Navigation))
    let loadProgressAnimationView: LoadProgressAnimationView = LoadProgressAnimationView(frame: CGRect(x:0, y:0, width:ZJScreenWidth, height:3))
    var loadURLStr: String? {
        didSet {
            webView.loadRequest(NSURLRequest(url: NSURL(string: loadURLStr!)! as URL) as URLRequest)
            
        }
    }
    
    var navTitle: String? {
        didSet {
            navigationItem.title = navTitle
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        buildWebView()
        webView.addSubview(loadProgressAnimationView)
    }
    private func buildWebView() {
        webView.delegate = self
        webView.backgroundColor = UIColor.white
        view.addSubview(webView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension CoupinRuleViewController: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        loadProgressAnimationView.startLoadPreogressAnimation()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadProgressAnimationView.endLoadPreogressAnimation()
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

