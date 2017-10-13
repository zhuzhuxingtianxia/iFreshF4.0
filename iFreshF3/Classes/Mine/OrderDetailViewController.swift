//
//  OrderDetailViewController.swift
//  iFreshF
//
//  Created by Jion on 16/5/26.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class OrderDetailViewController: BaseViewController {

    var scrollView: UIScrollView?
    let orderDetailView = OrderDetailView()
    let orderUserDetailView = OrderUserDetailView()
    var orderGoodsListView = OrderGoodsListView()
    let evaluateView = UIView()
    let evaluateLabel = UILabel()
    lazy var starImageViews: [UIImageView] = {
        var starImageViews: [UIImageView] = []
        for i in 0...4 {
            let starImageView = UIImageView(image: UIImage(named: "v2_star_no"))
            starImageViews.append(starImageView)
        }
        return starImageViews
    }()
    
    var order: Order? {
        didSet {
            orderDetailView.order = order
            orderUserDetailView.order = order
            orderGoodsListView.order = order
            evaluateLabel.text = order?.comment
            if  (order?.star)! > 0 {
                for i in 0..<order!.star {
                    let imageView = starImageViews[i]
                    imageView.image = UIImage(named: "v2_star_on")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        buildScrollView()
        
        buildOrderDetailView()
        
        buildOrderUserDetailView()
        
        buildOrderGoodsListView()
        
        bulidEvaluateView()
    }

    private func buildScrollView() {
        scrollView = UIScrollView(frame: CGRect(x:0 ,y:0 ,width:ZJScreenWidth ,height:ZJScreenHeight - Navigation - 50))
        scrollView?.alwaysBounceVertical = true
        scrollView?.backgroundColor = LFBGlobalBackgroundColor
        scrollView?.contentSize = CGSize(width:ZJScreenWidth, height:1000)
        view.addSubview(scrollView!)
    }
    private func buildOrderDetailView() {
        orderDetailView.frame = CGRect(x:0, y:10, width:ZJScreenWidth, height:185)
        
        scrollView?.addSubview(orderDetailView)
    }
    private func buildOrderUserDetailView() {
        orderUserDetailView.frame = CGRect(x:0, y:orderDetailView.frame.maxY + 10, width:ZJScreenWidth, height:110)
        
        scrollView?.addSubview(orderUserDetailView)
    }

    private func buildOrderGoodsListView() {
        orderGoodsListView.delegate = self
        scrollView?.addSubview(orderGoodsListView)
    }

    //评价
    private func bulidEvaluateView() {
        evaluateView.frame = CGRect(x:0, y:orderGoodsListView.frame.maxY + 10, width:ZJScreenWidth, height:100)
        evaluateView.backgroundColor = UIColor.white
        scrollView?.addSubview(evaluateView)
        
        let myEvaluateLabel = UILabel()
        myEvaluateLabel.text = "我的评价"
        myEvaluateLabel.textColor = LFBTextBlackColor
        myEvaluateLabel.font = UIFont.systemFont(ofSize: 14)
        myEvaluateLabel.frame = CGRect(x:10, y:5, width:ZJScreenWidth, height:25)
        evaluateView.addSubview(myEvaluateLabel)
        
        for i in 0...4 {
            let starImageView = starImageViews[i]
            starImageView.frame = CGRect(x:10 + CGFloat(i) * 30, y:myEvaluateLabel.frame.maxY + 5, width:25, height:25)
            evaluateView.addSubview(starImageView)
        }
        
        evaluateLabel.font = UIFont.systemFont(ofSize: 14)
        evaluateLabel.frame = CGRect(x:10, y:starImageViews[0].frame.maxY + 10, width:ZJScreenWidth - 20, height:25)
        evaluateLabel.textColor = LFBTextBlackColor
        evaluateView.addSubview(evaluateLabel)
        scrollView?.contentSize = CGSize(width:ZJScreenWidth, height:evaluateView.frame.maxY + 10 + 50 + Navigation)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension OrderDetailViewController: OrderGoodsListViewDelegate {
    
    func orderGoodsListViewHeightDidChange(height: CGFloat) {
        orderGoodsListView.frame = CGRect(x:0, y:orderUserDetailView.frame.maxY,width:ZJScreenWidth, height:height)
        evaluateView.frame = CGRect(x:0, y:orderGoodsListView.frame.maxY + 10, width:ZJScreenWidth, height:100)
        scrollView?.contentSize = CGSize(width:ZJScreenWidth, height:evaluateView.frame.maxY + 10)
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
