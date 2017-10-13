//
//  OrderViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/20.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class OrderViewController: BaseViewController {

    var orderTableView: LFBTableView!
    var orders: [Order]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       navigationItem.title = "我的订单"
       bulidOrderTableView()
    }

    private func bulidOrderTableView(){
        orderTableView = LFBTableView(frame: view.bounds, style: UITableViewStyle.plain)
        orderTableView.backgroundColor = view.backgroundColor
        orderTableView.delegate = self
        orderTableView.dataSource = self
        orderTableView.backgroundColor = UIColor.clear
        orderTableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0)
        view.addSubview(orderTableView)

        loadOderData()
    }
    
    private func loadOderData() {
        weak var tmpSelf = self
        OrderData.loadOrderData { (data, error) -> Void in
            tmpSelf!.orders = data?.data
            tmpSelf!.orderTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 }
extension OrderViewController: UITableViewDelegate, UITableViewDataSource, MyOrderCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MyOrderCell.myOrderCell(tableView: tableView, indexPath: indexPath as NSIndexPath)
        cell.order = orders![indexPath.row]
        cell.delegate = self
        return cell
    }
    func orderCellButtonDidClick(indexPath: NSIndexPath, buttonType: Int) {
        print(buttonType, indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailVC = OrderStatuslViewController()
        orderDetailVC.order = orders![indexPath.row]
        navigationController?.pushViewController(orderDetailVC, animated: true)
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


