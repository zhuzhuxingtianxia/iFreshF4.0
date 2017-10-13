//
//  AboutViewController.swift
//  iFreshF
//
//  Created by Jion on 16/5/24.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class AboutViewController: BaseViewController {

    private var authorLabel: UILabel!
    private var gitHubLabel: UILabel!
    private var sinaWeiBoLabel: UILabel!
    private var blogLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildAuthorImageView()
        
        bulidTextLabel()
        
        bulidGitHubLabel()
        
        bulidSinaLabel()
        
        bulidBlogLabel()
        
        buildURLButton()
    }

    // MARK: Build UI
    private func buildAuthorImageView() {
        navigationItem.title = "关于"
        
        let authorImageView = UIImageView(frame: CGRect(x:(ZJScreenWidth - 100) * 0.5, y:50, width:100, height:100))
        authorImageView.image = UIImage(named: "author")
        authorImageView.layer.masksToBounds = true
        authorImageView.layer.cornerRadius = 15
        view.addSubview(authorImageView)
    }
    private func bulidTextLabel() {
        authorLabel = UILabel()
        authorLabel.text = "猪猪行天下"
        authorLabel.sizeToFit()
        authorLabel.center.x = ZJScreenWidth * 0.5
        authorLabel.frame.origin.y = 170
        view.addSubview(authorLabel)
    }

    private func bulidGitHubLabel() {
        //frame: CGRectMake((ScreenWidth - gitHubLabel.width) * 0.5, CGRectGetMaxY(authorLabel.frame) + 10, gitHubLabel.width, gitHubLabel.height)
        gitHubLabel = UILabel()
        bulidTextLabel(label: gitHubLabel, text: "GitHub: " + "\(GitHubURLString)", tag: 1)
    }
    
    private func bulidSinaLabel() {
        sinaWeiBoLabel = UILabel()
        bulidTextLabel(label: sinaWeiBoLabel, text: "新浪微博: " + "\(SinaWeiBoURLString)", tag: 2)
    }
    private func bulidBlogLabel() {
        blogLabel = UILabel()
        bulidTextLabel(label: blogLabel, text: "技术博客: " + "\(BlogURLString)", tag: 3)
    }
    
    let buttonTitles = ["猪猪行天下Github", "猪猪行天下的微博", "猪猪行天下的博客"]
    let btnW: CGFloat = 90
    private func buildURLButton() {
        for i in 0...2 {
            let btn = UIButton()
            btn.setTitle(buttonTitles[i], for: .normal)
            btn.backgroundColor = UIColor.white
            btn.layer.cornerRadius = 5
            btn.tag = i
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 10)
            btn.titleLabel?.sizeToFit()
            btn.frame = CGRect(x:30 + CGFloat(i) * ((ZJScreenWidth - btnW * 3 - 60) / 2 + btnW), y:blogLabel.frame.maxY + 10, width:btnW, height:30)
            btn.addTarget(self, action: #selector(AboutViewController.btnClick(sender:)), for: UIControlEvents.touchUpInside)
            btn.setTitleColor(UIColor.black, for: UIControlState.normal)
            view.addSubview(btn)
        }
    }

    private func bulidTextLabel(label: UILabel, text: String, tag: Int) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 13)
        label.sizeToFit()
        label.isUserInteractionEnabled = true
        label.textColor = UIColor.colorWithRGB(r: 100, g: 100, b: 100)
        label.numberOfLines = 0
        
        switch tag {
        case 1: label.frame = CGRect(x:40, y:authorLabel.frame.maxY + 20, width:gitHubLabel.width, height:gitHubLabel.height + 10)
            break
        case 2: label.frame = CGRect(x:40, y:gitHubLabel.frame.maxY + 10, width:ZJScreenWidth, height:sinaWeiBoLabel.height + 10)
            break
        case 3: label.frame = CGRect(x:40, y:sinaWeiBoLabel.frame.maxY + 10, width:ZJScreenWidth - 40 - 50, height:40)
        default:break
        }
        
        label.tag = tag
        view.addSubview(label)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AboutViewController.textLabelClick(tap:)))
        label.addGestureRecognizer(tap)
    }

    // MARK: - Action
    @objc func textLabelClick(tap: UITapGestureRecognizer) {
        switch tap.view!.tag {
        case 1: UIApplication.shared.openURL(URL(string: GitHubURLString)!)
            break
        case 2: UIApplication.shared.openURL(URL(string: SinaWeiBoURLString)!)
            break
        default: UIApplication.shared.openURL(URL(string: BlogURLString)!)
            break
        }
    }
    
    @objc func btnClick(sender: UIButton) {
        switch sender.tag {
        case 0: UIApplication.shared.openURL(URL(string: GitHubURLString)!)
            break
        case 1: UIApplication.shared.openURL(URL(string: SinaWeiBoURLString)!)
            break
        case 2: UIApplication.shared.openURL(URL(string: BlogURLString)!)
            break
        default:
            break
        }
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

