//
//  OrderStatuslViewController.swift
//  iFreshF
//
//  Created by Jion on 16/5/25.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class OrderStatuslViewController: UIViewController {

    private var segment: LFBSegmentedControl!
    private var orderDetailTableView: LFBTableView?
    private var orderDetailVC: OrderDetailViewController?
    var orderStatuses: [OrderStatus]? {
        didSet {
            orderDetailTableView?.reloadData()
        }
    }
    var order: Order? {
        didSet {
            orderStatuses = order?.status_timeline
            
            if (order?.detail_buttons?.count)! > 0 {
                let btnWidth: CGFloat = 80
                let btnHeight: CGFloat = 30
                for i in 0..<order!.detail_buttons!.count {
                    let btn = UIButton(frame: CGRect(x:view.width - (10 + CGFloat(i + 1) * (btnWidth + 10)), y:view.height - 50 - Navigation + (50 - btnHeight) * 0.5, width:btnWidth, height:btnHeight))
                    btn.setTitle(order!.detail_buttons![i].text, for: UIControlState.normal)
                    btn.backgroundColor = LFBNavigationYellowColor
                    btn.setTitleColor(UIColor.black, for: .normal)
                    btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                    btn.layer.cornerRadius = 5;
                    btn.tag = order!.detail_buttons![i].type
                    btn.addTarget(self, action: #selector(OrderStatuslViewController.detailButtonClick(sender:)), for: UIControlEvents.touchUpInside)
                    view.addSubview(btn)
                }
            }

        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildNavigationItem()
        buildOrderDetailTableView()
        buildButtomView()
    }

    private func buildNavigationItem() {
        let rightItem = UIBarButtonItem.barButton(title: "投诉", titleColor: LFBTextBlackColor, target: self, action: #selector(OrderStatuslViewController.rightItemButtonClick))
        navigationItem.rightBarButtonItem = rightItem
        weak var tmpSelf = self
        segment = LFBSegmentedControl(items: ["订单状态" as AnyObject,"订单详情" as AnyObject], didSelectedIndex: { (index) in
            if index == 0 {
                tmpSelf?.showOrderStatusView()
            }else if index == 1 {
               tmpSelf?.showOrderDetailView()
            }
            
        })
        navigationItem.titleView = segment
        navigationItem.titleView?.frame = CGRect(x:0, y:5, width:180, height:27)
    }
   private func buildOrderDetailTableView() {
    
    orderDetailTableView = LFBTableView(frame: CGRect(x:0, y:0, width:ZJScreenWidth, height:ZJScreenHeight - Navigation), style: .plain)
    orderDetailTableView?.backgroundColor = UIColor.white
    orderDetailTableView?.delegate = self
    orderDetailTableView?.dataSource = self
    orderDetailTableView?.rowHeight = 80
    view.addSubview(orderDetailTableView!)
    
    }
    
   private func showOrderStatusView() {
    weak var tmpSelf = self
    tmpSelf!.orderDetailVC?.view.isHidden = true
    tmpSelf!.orderDetailTableView?.isHidden = false
    }
   private  func showOrderDetailView() {
     weak var tmpSelf = self
    if tmpSelf!.orderDetailVC == nil {
        tmpSelf!.orderDetailVC = OrderDetailViewController()
        tmpSelf!.orderDetailVC?.view.isHidden = false
        tmpSelf!.orderDetailVC?.order = order
        tmpSelf!.addChildViewController(orderDetailVC!)
        tmpSelf!.view.insertSubview(orderDetailVC!.view, at: 0)
    } else {
        tmpSelf!.orderDetailVC?.view.isHidden = false
    }
    tmpSelf!.orderDetailTableView?.isHidden = true
    }
    
    private func buildButtomView() {
        let bottomLine = UIView(frame: CGRect(x:0, y:view.height - 50 - Navigation, width:view.width, height:1))
        bottomLine.backgroundColor = UIColor.gray
        bottomLine.alpha = 0.1
        view.addSubview(bottomLine)
        
        let bottomView = UIView(frame: CGRect(x:0, y:view.height - 49 - Navigation, width:view.width, height:49))
        bottomView.backgroundColor = UIColor.white
        view.addSubview(bottomView)
    }
    
    // MARK: - Action
    @objc func rightItemButtonClick() {
        ProgressHUDManager.showSuccessWithStatus(string: "提交成功")
        
    }
    @objc func detailButtonClick(sender: UIButton) {
        ProgressHUDManager.showWithStatus(status: "正在" + "\((sender.titleLabel?.text)!)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            ProgressHUDManager.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                ProgressHUDManager.showSuccessWithStatus(string: "\((sender.titleLabel?.text)!)" + "成功")
                
            })
        })
        /*
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) { 
            ProgressHUDManager.dismiss()
             let time1 = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
            dispatch_after(time1, dispatch_get_main_queue(), { 
                ProgressHUDManager.showSuccessWithStatus("\((sender.titleLabel?.text)!)" + "成功")
            })
            
        }
 */
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension OrderStatuslViewController: UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderStatuses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OrderStatusCell.orderStatusCell(tableView: tableView)
        cell.orderStatus = orderStatuses![indexPath.row]
        
        if indexPath.row == 0 {
            cell.orderStateType = .Top
        } else if indexPath.row == orderStatuses!.count - 1 {
            cell.orderStateType = .Bottom
        } else {
            cell.orderStateType = .Middle
        }
        
        return cell
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
