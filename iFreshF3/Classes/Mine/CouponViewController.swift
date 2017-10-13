//
//  CouponViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/20.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit
// MARK: - HTMLURL
///优惠劵使用规则
public let CouponUserRuleURLString = "http://m.beequick.cn/show/webview/p/coupon?zchtauth=e33f2ac7BD%252BaUBDzk6f5D9NDsFsoCcna6k%252BQCEmbmFkTbwnA&__v=ios4.7&__d=d14ryS0MFUAhfrQ6rPJ9Gziisg%2F9Cf8CxgkzZw5AkPMbPcbv%2BpM4HpLLlnwAZPd5UyoFAl1XqBjngiP6VNOEbRj226vMzr3D3x9iqPGujDGB5YW%2BZ1jOqs3ZqRF8x1keKl4%3D"

class CouponViewController: BaseViewController {

     var bindingCouponView: BindingCouponView?
     var couponTableView: LFBTableView?
     var useCoupons: [Coupon] = [Coupon]()
     var unUseCoupons: [Coupon] = [Coupon]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setNavigationItem()
        
        buildBindingCouponView()
        
        bulidCouponTableView()
        
        loadCouponData()
    }

    // MARK: bulidUI
    private func setNavigationItem() {
        navigationItem.title = "优惠劵"
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem.barButton(title: "使用规则", titleColor: UIColor.colorWithRGB(r: 100, g: 100, b: 100), target: self, action: #selector(CouponViewController.rightItemClick))
        let tap = UITapGestureRecognizer(target: self, action: #selector(CouponViewController.tapKeyboardAction))
        view.addGestureRecognizer(tap)
    }
    
    func buildBindingCouponView() {
        bindingCouponView = BindingCouponView(frame: CGRect(x:0, y:0,width: ZJScreenWidth, height:50), bindingButtonClickBack: { (couponTextFiled) -> () in
            
            if couponTextFiled.text != nil && !(couponTextFiled.text!.isEmpty) {
                ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: "请输入正确的优惠劵")
            } else {
                let alert = UIAlertView(title: nil, message: "请输入优惠码!", delegate: nil, cancelButtonTitle: "确定")
                alert.show()
            }
            couponTextFiled.resignFirstResponder()
        })
        view.addSubview(bindingCouponView!)
    }
    
    private func bulidCouponTableView() {
        couponTableView = LFBTableView(frame: CGRect(x:0,y:bindingCouponView!.frame.maxY, width:ZJScreenWidth, height:ZJScreenHeight - bindingCouponView!.height - Navigation), style: UITableViewStyle.plain)
        couponTableView!.delegate = self
        couponTableView?.dataSource = self
        view.addSubview(couponTableView!)
    }

    
    // MARK: Method
    private func loadCouponData() {
        weak var tmpSelf = self
        CouponData.loadCouponData { (data, error) -> Void in
            if error != nil {
                return
            }
            
            if (data?.data?.count)! > 0 {
                for obj in data!.data! {
                    switch obj.status {
                    case 0: tmpSelf!.useCoupons.append(obj)
                        break
                    default: tmpSelf!.unUseCoupons.append(obj)
                        break
                    }
                }
            }
            
            tmpSelf!.couponTableView?.reloadData()
        }

    }
    
    // MARK: Action
    @objc func rightItemClick() {
        let couponRuleVC = CoupinRuleViewController()
        couponRuleVC.loadURLStr = CouponUserRuleURLString
        couponRuleVC.navTitle = "使用规则"
        navigationController?.pushViewController(couponRuleVC, animated: true)
    }
    
    @objc func tapKeyboardAction() {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

// - MARK: UITableViewDelegate, UITableViewDataSource
extension CouponViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if useCoupons.count > 0 && unUseCoupons.count > 0 {
            if 0 == section {
                return useCoupons.count
            } else {
                return unUseCoupons.count
            }
        }
        
        if useCoupons.count > 0 {
            return useCoupons.count
        }
        
        if unUseCoupons.count > 0 {
            return unUseCoupons.count
        }
        
        return 0
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if useCoupons.count > 0 && unUseCoupons.count > 0 {
            return 2
        } else if useCoupons.count > 0 || unUseCoupons.count > 0 {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CouponCell.cellWithTableView(tableView: tableView)
        var coupon: Coupon?
        if useCoupons.count > 0 && unUseCoupons.count > 0 {
            if 0 == indexPath.section {
                coupon = useCoupons[indexPath.row]
            } else {
                coupon = unUseCoupons[indexPath.row]
            }
        } else if useCoupons.count > 0 {
            coupon = useCoupons[indexPath.row]
        } else if unUseCoupons.count > 0 {
            coupon = unUseCoupons[indexPath.row]
        }
        
        cell.coupon = coupon!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if unUseCoupons.count > 0 && useCoupons.count > 0 && 0 == section {
            return 10
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if unUseCoupons.count > 0 && useCoupons.count > 0 {
            if 0 == section {
                let footView = UIView(frame: CGRect(x:0, y:0, width:ZJScreenWidth, height:10))
                footView.backgroundColor = UIColor.clear
                let lineView = UIView(frame: CGRect(x:CouponViewControllerMargin, y:4.5, width:ZJScreenWidth - 2 * CouponViewControllerMargin, height:1))
                lineView.backgroundColor = UIColor.colorWithRGB(r: 230, g: 230, b: 230)
                footView.addSubview(lineView)
                return footView
            } else {
                return nil
            }
        } else {
            return nil
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

