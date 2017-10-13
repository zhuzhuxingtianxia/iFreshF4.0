//
//  ProductsViewController.swift
//  iFreshF
//
//  Created by Jion on 16/5/9.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

@objc protocol ProductsViewControllerDelegate: NSObjectProtocol {
    @objc optional func didEndDisplayingHeaderView(section: Int)
    @objc optional func willDisplayHeaderView(section: Int)
}

class ProductsViewController: AnimationViewController {

     let headViewIdentifier   = "supermarketHeadView"
     var lastOffsetY: CGFloat = 0
     var isScrollDown         = false
    var productsTableView: LFBTableView?
     weak var delegate: ProductsViewControllerDelegate?
    var refreshUpPull:(() -> ())?
    
    var goodsArr: [[Goods]]? {
        didSet {
            productsTableView?.reloadData()
        }
    }
    var supermarketData: Supermarket? {
        didSet {
            self.goodsArr = Supermarket.searchCategoryMatchProducts(supermarketResouce: supermarketData!.data!)
        }
    }
    var categortsSelectedIndexPath: NSIndexPath? {
        didSet {
            productsTableView?.selectRow(at: IndexPath(row:0,section:categortsSelectedIndexPath!.row), animated: true, scrollPosition: .top)
            //productsTableView?.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: categortsSelectedIndexPath!.row), animated: true, scrollPosition: .Top)
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view = UIView(frame: CGRect(x:ZJScreenWidth * 0.25, y:0, width:ZJScreenWidth * 0.75, height:ZJScreenHeight - Navigation))
        buildProductsTableView()
    }

    // MARK: - Build UI
    private func buildProductsTableView() {
    
        productsTableView = LFBTableView(frame: view.bounds, style: .plain)
        productsTableView?.delegate = self
        productsTableView?.dataSource = self
        productsTableView?.backgroundColor = LFBGlobalBackgroundColor
        productsTableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 49, right: 0)
        productsTableView?.register(SupermarketHeadView.self, forHeaderFooterViewReuseIdentifier: headViewIdentifier)
        productsTableView?.tableFooterView = buildProductsTableViewTableFooterView()
        view.addSubview(productsTableView!)
        let headView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: #selector(ProductsViewController.startRefreshUpPull))
        productsTableView?.mj_header = headView
    }
    
    // MARK: - 上拉刷新
    @objc func startRefreshUpPull() {
        if refreshUpPull != nil {
            refreshUpPull!()
        }
    }
    
    private func buildProductsTableViewTableFooterView() -> UIView {
        let imageView = UIImageView(frame: CGRect(x:0, y:0, width:productsTableView!.width, height:70))
        imageView.contentMode = UIViewContentMode.center
        imageView.image = UIImage(named: "v2_common_footer")
        return imageView
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ProductsViewController: UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return supermarketData?.data?.categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (goodsArr != nil) && (goodsArr?.count)! > 0 {
            return self.goodsArr![section].count 
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = ProductCell.cellWithTableView(tableView: tableView)
        let goods = goodsArr![indexPath.section][indexPath.row]
        cell.goods = goods
        weak var tmpSelf = self
        cell.addProductClick = { (imageView) in
            tmpSelf?.addProductsAnimation(imageView: imageView)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headViewIdentifier) as! SupermarketHeadView
        if ((supermarketData?.data?.categories) != nil)  && supermarketData!.data!.categories![section].name != nil {
            headView.titleLabel.text = supermarketData!.data!.categories![section].name
        }
        
        return headView
    }
    
    //当区头将要显示时调用的方法
    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        
        if delegate != nil && delegate!.responds(to: #selector(ProductsViewControllerDelegate.didEndDisplayingHeaderView(section:))) && isScrollDown {
            delegate!.didEndDisplayingHeaderView!(section: section)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if delegate != nil && delegate!.responds(to: #selector(ProductsViewControllerDelegate.willDisplayHeaderView(section:))) && !isScrollDown {
            delegate!.willDisplayHeaderView!(section: section)
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goods = goodsArr![indexPath.section][indexPath.row]
        let productDetailVC = ProductDetailViewController(goods: goods)
        navigationController?.pushViewController(productDetailVC, animated: true)
    }

}

// MARK: - UIScrollViewDelegate
extension ProductsViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (animationLayers != nil) && (animationLayers?.count)! > 0 {
            let transitionLayer = animationLayers![0]
            transitionLayer.isHidden = true
        }
        
        isScrollDown = lastOffsetY < scrollView.contentOffset.y
        lastOffsetY = scrollView.contentOffset.y
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


