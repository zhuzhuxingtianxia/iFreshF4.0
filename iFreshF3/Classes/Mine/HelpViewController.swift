//
//  HelpViewController.swift
//  iFreshF
//
//  Created by Jion on 16/5/30.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

enum HelpCellType: Int {
    case Phone = 0
    case Question = 1
}

class HelpViewController: BaseViewController {
    
    let margin: CGFloat = 20
    let backView: UIView = UIView(frame: CGRect(x:0, y:10, width:ZJScreenWidth, height:100))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "客服帮助"
        
        backView.backgroundColor = UIColor.white
        view.addSubview(backView)
        
        let phoneLabel = UILabel(frame: CGRect(x:margin, y:0, width:ZJScreenWidth - 2 * margin,height:50))
        creatLabel(label: phoneLabel, text: "客服电话: 400-8484-842", type: HelpCellType.Phone)
        let questionLabel = UILabel(frame: CGRect(x:margin, y:50, width:ZJScreenWidth - 2 * margin, height:50))
        creatLabel(label: questionLabel, text: "常见问题", type: HelpCellType.Question)
    }
    
    //MARK: - Method
    private func creatLabel(label: UILabel,text: String,type: HelpCellType) {
        label.text = text
        label.isUserInteractionEnabled = true
        label.font = UIFont.systemFont(ofSize: 15)
        label.tag = type.hashValue
        backView.addSubview(label)
        
        if type == HelpCellType.Phone {
            let lineView = UIView(frame: CGRect(x:0, y:label.frame.maxY - 1, width:ZJScreenWidth - margin, height:1))
            lineView.backgroundColor = UIColor.gray
            lineView.alpha = 0.2
            label.addSubview(lineView)
        }
        
        let arrowImage = UIImageView(image: UIImage(named: "icon_go"))
        arrowImage.frame = CGRect(x:ZJScreenWidth - 20, y:label.frame.origin.y + (label.frame.size.height - 10) * 0.5, width:5, height:10)
        backView.addSubview(arrowImage)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cellClick(tap:)))
        label.addGestureRecognizer(tap)
    }

    // MARK: - Action
    @objc func cellClick(tap: UITapGestureRecognizer) {
        
        switch tap.view!.tag {
        case HelpCellType.Phone.hashValue:
            let alertView = UIAlertView(title: "", message: "400-8484-842", delegate: self, cancelButtonTitle: "取消", otherButtonTitles: "拨打")
            alertView.show()
            
        case HelpCellType.Question.hashValue:
            let helpDetailVC = HelpDetailViewController()
            navigationController?.pushViewController(helpDetailVC, animated: true)
        default:break
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension HelpViewController: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            var number: String?
            //判断包含
            if alertView.message!.components(separatedBy: "-").count>0 {
                //字符替换
                number = alertView.message?.cleanSpace().replacingOccurrences(of: "-", with: "")
            }else{
                
                number = alertView.message?.cleanSpace()
            }
            
            UIApplication.shared.openURL(NSURL(string: "tel:" + number!)! as URL)
        }
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

