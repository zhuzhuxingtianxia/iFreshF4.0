//
//  MineViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/13.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController {

    private var headView:MineHeadView!
    private var tableVew:LFBTableView!
    private var headViewHeight: CGFloat = 130 + statusBarH
    private var tableHeadView: MineTabeHeadView!
    private var couponNum:Int = 0
    let shareActionSheet:LFBActionSheet = LFBActionSheet()
    
    // MARK: Flag
    var iderVCSendIderSuccess = false
    // MARK: Lazy Property
    lazy var mines: [MineCellModel] = {
        let mines = MineCellModel.loadMineCellModels()
        return mines
    }()

    
    // MARK:- view life circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
       UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: false)
        weak var tmpSelf = self
        Mine.loadMineData { (data, error) in
            if error == nil {
                if (data?.data?.availble_coupon_num)! > 0{
                
                    tmpSelf!.couponNum = data!.data!.availble_coupon_num
                    tmpSelf!.tableHeadView.setCouponNumer(number: data!.data!.availble_coupon_num)
                }else{
                     tmpSelf!.tableHeadView.setCouponNumer(number: 0)
                }
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if iderVCSendIderSuccess {
            ProgressHUDManager.showSuccessWithStatus(string: "已经收到你的意见了,我们会改正的,放心吧~~")
            iderVCSendIderSuccess = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK:- Private Method
    // MARK: Build UI
    private func buildUI(){
        weak var tmpSelf = self
        headView = MineHeadView(frame: CGRect(x:0, y:0, width:ZJScreenWidth, height:headViewHeight), settingButtonClick: {
            //进入设置界面
            let settingVC = SettingViewController()
            tmpSelf!.navigationController?.pushViewController(settingVC, animated: true)
            
        })
        view.addSubview(headView)
        buildTableView()
    }
    
    private func buildTableView() {
        tableVew = LFBTableView(frame: CGRect(x:0, y:headViewHeight, width:ZJScreenWidth, height:ZJScreenHeight - headViewHeight), style: .grouped)
        tableVew.delegate = self
        tableVew.dataSource = self
        tableVew.estimatedSectionFooterHeight = 0
        tableVew.estimatedSectionHeaderHeight = 0
        tableVew.rowHeight = 46
        view.addSubview(tableVew)
        
        weak var tmpSelf = self
        tableHeadView = MineTabeHeadView(frame: CGRect(x:0,y:0,width:ZJScreenWidth,height:70))
        //点击headView回调
        tableHeadView.mineHeadViewClick = { (type) ->  () in
            switch type {
            case .Order:
                let orderVC = OrderViewController()
                tmpSelf!.navigationController?.pushViewController(orderVC, animated: true)
            case .Coupon:
                let couponVC = CouponViewController()
                tmpSelf?.navigationController?.pushViewController(couponVC, animated: true)
            case .Message:
                let message = MessageViewController()
                tmpSelf!.navigationController?.pushViewController(message, animated: true)
                
            }
            
        }
        
        tableVew.tableHeaderView = tableHeadView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

/// MARK:- UITableViewDataSource UITableViewDelegate
extension MineViewController:UITableViewDelegate,UITableViewDataSource {
    //区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    //行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if 0 == section {
            return 2
        }else if 1 == section{
            return 1
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    //cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MineCell.cellFor(tableView: tableView)
        if 0 == indexPath.section {
            cell.mineModel = mines[indexPath.row]
        }else if 1 == indexPath.section {
            cell.mineModel = mines[2]
        }else {
            if indexPath.row == 0 {
                cell.mineModel = mines[3]
            } else {
                cell.mineModel = mines[4]
            }
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if 0 == indexPath.section {
            if 0 == indexPath.row {
                let adressVC = MyAdressViewController()
                navigationController?.pushViewController(adressVC, animated: true)
            } else {
                let myShopVC = MyShopViewController()
                navigationController?.pushViewController(myShopVC, animated: true)
            }
        } else if 1 == indexPath.section {
            shareActionSheet.showActionSheetViewShowInView(inView: view) { (shareType) -> () in
                let goods = Goods()
                goods.url = "http://weibo.com/u/5154294545?topnav=1&wvr=6&topsug=1&is_all=1"
                goods.name = "猪猪行天下"
                ShareManager.shareToShareType(shareType: shareType, shareModel: goods, vc: self)
            }
        } else if 2 == indexPath.section {
            if 0 == indexPath.row {
                let helpVc = HelpViewController()
                navigationController?.pushViewController(helpVc, animated: true)
            } else if 1 == indexPath.row {
                let ideaVC = IdeaViewController()
                ideaVC.mineVC = self
                navigationController!.pushViewController(ideaVC, animated: true)
            }
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
