//
//  OrderPayWayViewController.swift
//  iFreshF
//
//  Created by Jion on 16/5/9.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class OrderPayWayViewController: BaseViewController {

    private var scrollView = UIScrollView(frame: CGRect(x:0,y:0,width:ZJScreenWidth,height:ZJScreenHeight - 64 - 50))
    private var tableHeaderView = UIView(frame: CGRect(x:0, y:0, width:ZJScreenWidth, height:40 + 15 + 190 + 30))
    private let leftMargin: CGFloat = 15
    private var priceText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         navigationItem.title = "结算付款"
       buildScrollView()
        // Do any additional setup after loading the view.
    }

    private func buildScrollView() {
        
        scrollView.backgroundColor = UIColor.clear
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.addSubview(tableHeaderView)
        buildTableHeaderView()
    }
    
    private func buildTableHeaderView() {
        tableHeaderView.backgroundColor = UIColor.clear
        buildCouponView()
        buildPayView()
        buildCarefullyView()
    }
    private func buildCouponView(){
        let couponView = UIView(frame: CGRect(x:0,y:0,width:ZJScreenWidth,height:40))
        couponView.backgroundColor = UIColor.white
        tableHeaderView.addSubview(couponView)
        
        let couponImageView = UIImageView(image: UIImage(named: "v2_submit_Icon"))
        couponImageView.frame = CGRect(x:leftMargin, y:10, width:20, height:20)
        couponView.addSubview(couponImageView)
        
        let couponLabel = UILabel(frame: CGRect(x:couponImageView.frame.maxX + 10,y:0 ,width:ZJScreenWidth * 0.4,height:40))
        couponLabel.text = "1张优惠券"
        couponLabel.textColor = UIColor.red
        couponLabel.font = UIFont.systemFont(ofSize: 14)
        couponView.addSubview(couponLabel)
        
        let arrowImageView = UIImageView(image: UIImage(named: "icon_go"))
        arrowImageView.frame = CGRect(x:ZJScreenWidth - 10 - 5, y:15, width:5, height:10)
        couponView.addSubview(arrowImageView)
        
        let checkButton = UIButton(frame: CGRect(x:ZJScreenWidth - 60,y:0,width:40,height:40))
        checkButton.setTitle("查看", for: UIControlState.normal)
        checkButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        checkButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        checkButton.addTarget(self, action: #selector(OrderPayWayViewController.checkCoupon), for: UIControlEvents.touchUpInside)
        couponView.addSubview(checkButton)
        
        buildLineView(addView: couponView, lineFrame: CGRect(x:0, y:40 - 1, width:ZJScreenWidth, height:1))
    }
    
    private func buildPayView() {
        let payView = UIView(frame: CGRect(x:0, y:55, width:ZJScreenWidth, height:190))
        payView.backgroundColor = UIColor.white
        tableHeaderView.addSubview(payView)
        buildLabel(labelFrame: CGRect(x:leftMargin, y:0, width:150, height:30), textColor: UIColor.lightGray, font: UIFont.systemFont(ofSize: 12), addView: payView, text: "选择支付方式")
        let payV = PayView(frame: CGRect(x:0, y:30, width:ZJScreenWidth, height:160))
        payView.addSubview(payV)
        
        buildLineView(addView: payView, lineFrame: CGRect(x:0, y:189, width:ZJScreenWidth, height:1))
 
    }
    
    private func buildCarefullyView() {
        let carefullyView = UIView(frame: CGRect(x:0, y:40 + 15 + 190 + 15, width:ZJScreenWidth, height:30))
        carefullyView.backgroundColor = UIColor.white
        tableHeaderView.addSubview(carefullyView)
        
        buildLabel(labelFrame: CGRect(x:leftMargin, y:0, width:150, height:30), textColor: UIColor.lightGray, font: UIFont.systemFont(ofSize: 12), addView: carefullyView, text: "精选商品")
        
        let goodsView = ShopCartGoodsListView(frame: CGRect(x:0,y:carefullyView.frame.maxY,width:ZJScreenWidth,height:300))
        goodsView.frame.size.height = goodsView.goodsHeight
        scrollView.addSubview(goodsView)
        
        let costDetailView = CostDetailView(frame: CGRect(x:0,y:goodsView.frame.maxY + 10,width:ZJScreenWidth,height:135))
        scrollView.addSubview(costDetailView)
        
        scrollView.contentSize = CGSize(width:ZJScreenWidth, height:costDetailView.frame.maxY + 15)
        
        let bottomView = UIView(frame: CGRect(x:0,y:ZJScreenHeight - 50 - 64,width:ZJScreenWidth,height:50))
        bottomView.backgroundColor = UIColor.white
        buildLineView(addView: bottomView, lineFrame: CGRect(x:0, y:0, width:ZJScreenWidth, height:1))
        view.addSubview(bottomView)
        
        buildLabel(labelFrame: CGRect(x:leftMargin, y:0, width:80, height:50), textColor: UIColor.black, font: UIFont.systemFont(ofSize: 14), addView: bottomView, text: "实付金额:")
        
         priceText = costDetailView.coupon == "0" ? UserShopCarTool.sharedUserShopCar.getAllProductsPrice() : "\((UserShopCarTool.sharedUserShopCar.getAllProductsPrice() as NSString).floatValue - 5)"
        if (priceText! as NSString).floatValue < 30 {
            priceText = "\((priceText! as NSString).floatValue + 8)".cleanDecimalPointZero()
        }
        buildLabel(labelFrame: CGRect(x:85, y:0, width:150, height:50), textColor: UIColor.red, font: UIFont.systemFont(ofSize: 14), addView: bottomView, text: "$" + priceText!)
        let payButton = UIButton(frame: CGRect(x:ZJScreenWidth - 100, y:1, width:100, height:49))
        payButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        payButton.setTitle("确认付款", for: UIControlState.normal)
        payButton.backgroundColor = LFBNavigationYellowColor
        payButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        payButton.addTarget(self, action: #selector(OrderPayWayViewController.paymentAction), for: UIControlEvents.touchUpInside)
        bottomView.addSubview(payButton)
    }
    
    //MARK: --确认支付
    @objc func paymentAction() {
        
        print("总价:\(priceText!)")
        let goodses = UserShopCarTool.sharedUserShopCar.getShopCarProducts()
       let arry = DictModelManager.sharedManager.objectArray(array: goodses)
        print("\(arry)")
        
        ProgressHUDManager.showWithStatus(status: "正在提交")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            ProgressHUDManager.dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                ProgressHUDManager.showErrorWithStatus(string: "支付失败")
                
            })
        })
        /*
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) {
            ProgressHUDManager.dismiss()
            let time1 = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
            dispatch_after(time1, dispatch_get_main_queue(), {
//                ProgressHUDManager.showSuccessWithStatus("支付成功")
                ProgressHUDManager.showErrorWithStatus("支付失败")
            })
            
        }
 */
    }
    
    private func buildLineView(addView: UIView, lineFrame: CGRect) {
        let lineView = UIView(frame: lineFrame)
        lineView.backgroundColor = UIColor.black
        lineView.alpha = 0.1
        addView.addSubview(lineView)
    }
    
    private func buildLabel(labelFrame: CGRect, textColor: UIColor, font: UIFont, addView: UIView, text: String) {
        let label = UILabel(frame: labelFrame)
        label.textColor = textColor
        label.font = font
        label.text = text
        addView.addSubview(label)
    }
    
   //MARK:--Action
    @objc func checkCoupon() {
        let couponVC = CouponViewController()
        navigationController?.pushViewController(couponVC, animated: true)
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


