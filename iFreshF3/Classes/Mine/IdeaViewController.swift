//
//  IdeaViewController.swift
//  iFreshF
//
//  Created by Jion on 16/5/30.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class IdeaViewController: BaseViewController {

    private let margin: CGFloat = 15
    private var promptLabel: UILabel!
    weak var mineVC: MineViewController?
    private var iderTextView: PlaceholderTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
        
        buildRightNaviItem()
        
        buildNoteLabel()
        
        buildIdeaTextView()
    }

    
    // MARK: - Build UI
    private func setUpUI() {
        view.backgroundColor = LFBGlobalBackgroundColor
        navigationItem.title = "意见反馈"
    }
    private func buildRightNaviItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton(title: "发送", titleColor: UIColor.colorWithRGB(r: 100, g: 100, b: 100), target: self, action: #selector(IdeaViewController.rightItemClick))
    }
    
    private func buildNoteLabel() {
        promptLabel = UILabel(frame: CGRect(x:margin, y:5, width:ZJScreenWidth - 2 * margin, height:50))
        promptLabel.text = "你的批评和建议能帮助我们更好的完善产品,请留下你的宝贵意见!"
        promptLabel.numberOfLines = 0
        promptLabel.textColor = UIColor.black
        promptLabel.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(promptLabel)
    }
    
    private func buildIdeaTextView() {
        iderTextView = PlaceholderTextView(frame: CGRect(x:margin, y:promptLabel.frame.maxY + 10, width:ZJScreenWidth - 2 * margin, height:150))
        iderTextView.delegate = self
        iderTextView.placeholder = "请输入宝贵意见(300字以内)"
        iderTextView.becomeFirstResponder()
        view.addSubview(iderTextView)
    }
    
    // MARK: - Action
    @objc func rightItemClick() {
        if iderTextView.text == nil || 0 == iderTextView.text?.characters.count {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: "请输入意见,心里空空的")
        } else if (iderTextView.text?.characters.count)! < 5 {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: "请输入超过5个字啊亲~")
        } else if (iderTextView.text?.characters.count)! >= 300 {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: "说的太多了,臣妾做不到啊~")
        } else {
            ProgressHUDManager.showWithStatus(status: "发送中")
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
               _ = self.navigationController?.popViewController(animated: true)
                self.mineVC?.iderVCSendIderSuccess = true
                ProgressHUDManager.dismiss()
            })
            
            /*
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(time, dispatch_get_main_queue(), { () -> Void in
                self.navigationController?.popViewControllerAnimated(true)
                self.mineVC?.iderVCSendIderSuccess = true
                ProgressHUDManager.dismiss()
            })
 */
        }
    

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}

extension IdeaViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton(title: "发送", titleColor: UIColor.blue, target: self, action: #selector(IdeaViewController.rightItemClick))
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
