//
//  SupermarketViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/13.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class SupermarketViewController: SelectedAdressViewController {

     var categoryTableView: LFBTableView!
    var supermarketData: Supermarket?
     var productsVC: ProductsViewController!
    
    // flag
    private var categoryTableViewIsLoadFinish = false
    private var productTableViewIsLoadFinish  = false

    override func viewDidLoad() {
        super.viewDidLoad()

       addNotification()
       showProgressHUD()
       bulidCategoryTableView()
       bulidProductsViewController()
       loadSupermarketData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if productsVC.productsTableView != nil {
            productsVC.productsTableView?.reloadData()
        }
        //这个通知其实是刷新重新添加tabbar购物车上面的红点
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LFBSearchViewControllerDeinit"), object: nil)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    
    private func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(SupermarketViewController.shopCarBuyProductNumberDidChange), name: NSNotification.Name(rawValue: LFBShopCarBuyProductNumberDidChangeNotification), object: nil)
    }
    
    @objc func shopCarBuyProductNumberDidChange() {
        if productsVC.productsTableView != nil {
            productsVC.productsTableView!.reloadData()
        }
    }
    // MARK:- Creat UI
    private func bulidCategoryTableView() {
        categoryTableView = LFBTableView(frame: CGRect(x:0, y:0, width:ZJScreenWidth * 0.25, height:ZJScreenHeight), style: .plain)
        categoryTableView.backgroundColor = LFBGlobalBackgroundColor
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.showsVerticalScrollIndicator = false
        categoryTableView.showsHorizontalScrollIndicator = false
        categoryTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Navigation, right: 0)
        categoryTableView.isHidden = true
        view.addSubview(categoryTableView)
    }
    
    private func bulidProductsViewController() {
        productsVC = ProductsViewController()
        productsVC.delegate = self
        productsVC.view.isHidden = true
        addChildViewController(productsVC)
        view.addSubview(productsVC.view)

        productsVC.refreshUpPull = {
            
            self.productsVC.productsTableView?.mj_header.endRefreshing()
        }
    }
    
    private func loadSupermarketData() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            weak var tmpSelf = self
            Supermarket.loadSupermarketData(completion: { (data, error) in
                if data != nil {
                    tmpSelf!.supermarketData = data
                    tmpSelf!.categoryTableView.reloadData()
                    tmpSelf!.categoryTableView.selectRow(at: IndexPath(row:0,section:0), animated: true, scrollPosition: UITableViewScrollPosition.bottom)
                  
                    tmpSelf!.productsVC.supermarketData = data
                    tmpSelf!.categoryTableViewIsLoadFinish = true
                    tmpSelf!.productTableViewIsLoadFinish = true
                    
                    if tmpSelf!.categoryTableViewIsLoadFinish && tmpSelf!.productTableViewIsLoadFinish {
                        tmpSelf!.categoryTableView.isHidden = false
                        tmpSelf!.productsVC.productsTableView!.isHidden = false
                        tmpSelf!.productsVC.view.isHidden = false
                        
                        ProgressHUDManager.dismiss()
                        tmpSelf!.view.backgroundColor = LFBGlobalBackgroundColor
                    }
                }
            })

        })
        
        /*
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) { 
            weak var tmpSelf = self
            Supermarket.loadSupermarketData({ (data, error) in
                if data != nil {
                    tmpSelf!.supermarketData = data
                    tmpSelf!.categoryTableView.reloadData()
                    tmpSelf!.categoryTableView.selectRowAtIndexPath(NSIndexPath(forRow: 0 ,inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Bottom)
                    tmpSelf!.productsVC.supermarketData = data
                    tmpSelf!.categoryTableViewIsLoadFinish = true
                    tmpSelf!.productTableViewIsLoadFinish = true
                    
                    if tmpSelf!.categoryTableViewIsLoadFinish && tmpSelf!.productTableViewIsLoadFinish {
                        tmpSelf!.categoryTableView.hidden = false
                        tmpSelf!.productsVC.productsTableView!.hidden = false
                        tmpSelf!.productsVC.view.hidden = false
                        
                        ProgressHUDManager.dismiss()
                        tmpSelf!.view.backgroundColor = LFBGlobalBackgroundColor
                    }
                }
            })
        }
 */
        
    }

    // MARK: - Private Method
    private func showProgressHUD() {
        ProgressHUDManager.setBackgroundColor(color: UIColor.colorWithRGB(r: 230, g: 230, b: 230))
        view.backgroundColor = UIColor.white
        if !ProgressHUDManager.isVisible() {
            ProgressHUDManager.showWithStatus(status: "正在加载中")
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
// MARK: - UITableViewDelegate, UITableViewDataSource
extension SupermarketViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supermarketData?.data?.categories?.count ?? 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CategoryCell.cellWithTableView(tableView: tableView)
        cell.categorie = supermarketData?.data?.categories![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if productsVC != nil {
            productsVC.categortsSelectedIndexPath = indexPath as NSIndexPath?
        }
    }
}

// MARK: - SupermarketViewController
extension SupermarketViewController: ProductsViewControllerDelegate {
    func didEndDisplayingHeaderView(section: Int) {
        
        categoryTableView.selectRow(at: IndexPath(row:section + 1,section:0), animated: true, scrollPosition: UITableViewScrollPosition.middle)
        
    }
    
    func willDisplayHeaderView(section: Int) {
        categoryTableView.selectRow(at: IndexPath(row:section,section:0), animated: true, scrollPosition: UITableViewScrollPosition.middle)
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

