//
//  MessageViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/20.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class MessageViewController: BaseViewController {

    private var segment: LFBSegmentedControl!
    private var systemTableView: LFBTableView!
    var systemMessage: [UserMessage]?
    private var userMessage: [UserMessage]?
    private var secondView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bulidSystemTableView()
        bulidSecontView()
        bulidSegmentedControl()
        showSystemTableView()
        loadSystemMessage()
    }

    private func bulidSegmentedControl() {
        weak var tmpSelf = self
        segment = LFBSegmentedControl(items: ["系统消息" as AnyObject, "用户消息" as AnyObject], didSelectedIndex: { (index) -> () in
            if 0 == index {
                tmpSelf!.showSystemTableView()
            } else if 1 == index {
                tmpSelf!.showUserTableView()
            }
        })
        navigationItem.titleView = segment
        navigationItem.titleView?.frame = CGRect(x:0, y:5, width:180, height:27)
    }

    private func bulidSystemTableView() {
        systemTableView = LFBTableView(frame: view.bounds, style: .plain)
        systemTableView.backgroundColor = LFBGlobalBackgroundColor
        systemTableView.showsHorizontalScrollIndicator = false
        systemTableView.showsVerticalScrollIndicator = false
        systemTableView.delegate = self
        systemTableView.dataSource = self
        systemTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)
        view.addSubview(systemTableView)
        
        loadSystemTableViewData()
    }
    private func loadSystemTableViewData() {
        weak var tmpSelf = self
        UserMessage.loadSystemMessage { (data, error) -> () in
            tmpSelf!.systemMessage = data
            tmpSelf!.systemTableView.reloadData()
        }
    }
    private func loadSystemMessage() {
        weak var tmpSelf = self
        UserMessage.loadSystemMessage { (data, error) -> () in
            tmpSelf!.systemMessage = data
            tmpSelf!.systemTableView.reloadData()
        }
    }
    
    private func bulidSecontView() {
        secondView = UIView(frame: CGRect(x:0, y:0, width:ZJScreenWidth, height:ZJScreenHeight - 64))
        secondView?.backgroundColor = LFBGlobalBackgroundColor
        view.addSubview(secondView!)
        
        let normalImageView = UIImageView(image: UIImage(named: "v2_my_message_empty"))
        normalImageView.center = view.center
        normalImageView.center.y -= 150
        secondView?.addSubview(normalImageView)
        
        let normalLabel = UILabel()
        normalLabel.text = "~~~并没有消息~~~"
        normalLabel.textAlignment = NSTextAlignment.center
        normalLabel.frame = CGRect(x:0, y:normalImageView.frame.maxY + 10, width:ZJScreenWidth, height:50)
        secondView?.addSubview(normalLabel)
    }

    private func showSystemTableView() {
        secondView?.isHidden = true
    }
    
    private func showUserTableView() {
        secondView?.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SystemMessageCell.systemMessageCell(tableView: tableView)
        cell.message = systemMessage![indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return systemMessage?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = systemMessage![indexPath.row]
        
        return message.cellHeight
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
