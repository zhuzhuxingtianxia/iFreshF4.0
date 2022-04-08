//
//  HomeViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/13.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class HomeViewController: SelectedAdressViewController {

     var headView: HomeTableHeadView?
     var collectionView: LFBCollectionView!
     var headData:HeadResources?
     var freshHot:FreshHot?
     var isAnimation: Bool = false
     var lastContentOffsetY: CGFloat = 0
    
    // MARK: - Life circle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addHomeNotification()
        buildCollectionView()
        buildTableHeadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if collectionView != nil {
            collectionView.reloadData()
        }
    //??对于这个通知我很疑惑，为什么push后回来购物车小红点就不见了呢
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LFBSearchViewControllerDeinit"), object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    // MARK:- addNotifiation
    func addHomeNotification() {
        //tableHeadView高度发生改变的通知
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.homeTableHeadViewHeightDidChange(noti:)), name: NSNotification.Name(rawValue: HomeTableHeadViewHeightDidChange), object: nil)
        //库存不足的通知
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.goodsInventoryProblem(noti:)), name: NSNotification.Name(rawValue: HomeGoodsInventoryProblem), object: nil)
        //购物车商品数量改变的通知
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.shopCarBuyProductNumberDidChange), name: NSNotification.Name(rawValue: LFBShopCarBuyProductNumberDidChangeNotification), object: nil)
    }
    
    // MARK:- Creat UI
    private func buildTableHeadView() {
       headView = HomeTableHeadView()
        headView!.delegate = self
        weak var tmpSelf = self
        
        HeadResources.loadHomeHeadData { (data, error) in
            if data != nil{
                tmpSelf?.headView?.headData = data
               tmpSelf?.headData = data
               tmpSelf?.collectionView.reloadData()
            }
        }
        
        collectionView.addSubview(headView!)
        
        FreshHot.loadFreshHotData { (data, error) in
            if (data != nil) {
                tmpSelf?.freshHot = data
                tmpSelf?.collectionView.reloadData()
            }
        }
    }
    
    private func buildCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 0, left: HomeCollectionViewCellMargin, bottom: 0, right: HomeCollectionViewCellMargin)
        layout.headerReferenceSize = CGSize(width:0, height:HomeCollectionViewCellMargin)
        
        collectionView = LFBCollectionView(frame: CGRect(x:0, y:0, width:ZJScreenWidth, height:ZJScreenHeight - 64), collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = LFBGlobalBackgroundColor
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: "Cell")
//        collectionView.register(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.register(HomeCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView")
        collectionView.register(HomeCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")
        
        view.addSubview(collectionView)
        //?????为什么会偏移？？？
//        let refreshHeadView = LFBRefreshHeader(refreshingTarget: self, refreshingAction: #selector(HomeViewController.headRefresh))
//        collectionView.header = refreshHeadView
    }
    // MARK: 刷新
    func headRefresh() {
        
        collectionView.mj_header.endRefreshing()
    }
    
    // MARK: Notifiation Action
    @objc func homeTableHeadViewHeightDidChange(noti: NSNotification)  {
        collectionView!.contentInset = UIEdgeInsetsMake(noti.object as! CGFloat, 0, Navigation, 0)
        collectionView!.setContentOffset(CGPoint(x:0, y:-(collectionView!.contentInset.top)), animated: false)
        
        lastContentOffsetY = collectionView.contentOffset.y
    }
    
    @objc func goodsInventoryProblem(noti: NSNotification) {
        if let goodsName = noti.object as? String {
            ProgressHUDManager.showImage(image: UIImage(named: "v2_orderSuccess")!, status: goodsName + "\n库存不足了\n先买这么多吧~")
        }
    }
    
    @objc func shopCarBuyProductNumberDidChange() {
        
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

// MARK:- HomeHeadViewDelegate
extension HomeViewController: HomeTableHeadViewDelegate {
    
    func tabelheadView(headView: HomeTableHeadView, focusImageViewClick index: Int) {
        if (headData?.data?.focus?.count)! > 0 {
            let path = Bundle.main.path(forResource: "FocusURL", ofType: "plist")
            
            let array = NSArray(contentsOfFile: path!)
            let name = headView.headData!.data!.focus![index].name!
            let webVC = WebViewController(navtigationTitle: name, urlStr: array![index] as! String)
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    func tableHeadView(headView: HomeTableHeadView, iconClick index: Int) {
        if (headData?.data?.icons?.count)! > 0 {
            let icons = headView.headData!.data!.icons
            let webVC = WebViewController(navtigationTitle: icons![index].name!, urlStr: icons![index].customURL!)
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
}

//MARK:- UICollectionViewDelegate UICollectionViewDataSource
extension HomeViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if (headData?.data?.activities?.count)! <= 0 || (freshHot?.data?.count)! <= 0 {
            return 0
        }
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (headData?.data?.activities?.count)! <= 0 || (freshHot?.data?.count)! <= 0 {
            return 0
        }
        
        if section == 0 {
            
            return headData?.data?.activities?.count ?? 0
        }else if section == 1{
            return freshHot?.data?.count ?? 0
        }
        
        return 0
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! HomeCell
        if indexPath.section == 0 {
            cell.activities = headData!.data!.activities![indexPath.row]
        }else if indexPath.section == 1{
            cell.goods = freshHot!.data![indexPath.row]
            weak var tmpSelf = self
            cell.addButtonClick = ({(imageView) in
                tmpSelf?.addProductsAnimation(imageView: imageView)
                })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var itemSize = CGSize.zero
        if indexPath.section == 0 {
            itemSize = CGSize(width:ZJScreenWidth - HomeCollectionViewCellMargin * 2, height:140)
        } else if indexPath.section == 1 {
            itemSize = CGSize(width:(ZJScreenWidth - HomeCollectionViewCellMargin * 2) * 0.5 - 4, height:250)
        }
        
        return itemSize
    }
    //区头大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width:ZJScreenWidth, height:HomeCollectionViewCellMargin)
        }else if section == 1{
            return CGSize(width:ZJScreenWidth, height:HomeCollectionViewCellMargin * 2)
        }
        return CGSize.zero
    }
    //区尾大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width:ZJScreenWidth, height:HomeCollectionViewCellMargin)
        }else if section == 1{
            return CGSize(width:ZJScreenWidth, height:HomeCollectionViewCellMargin * 5)
        }
        return CGSize.zero
    }
    //区头区尾视图
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
//            if  indexPath.section == 1 {
                let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath) as! HomeCollectionHeaderView
                return headView
//            }
            
        }
        
        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView", for: indexPath) as! HomeCollectionFooterView
        if indexPath.section == 1, kind == UICollectionElementKindSectionFooter {
            footerView.showLabel()
            footerView.tag = 100
        }else{
            footerView.hideLabel()
            footerView.tag = 1
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.moreGoodsClick(tap:)))
        footerView.addGestureRecognizer(tap)
        return footerView
    }
    
    // MARK: 查看更多商品被点击
    @objc func moreGoodsClick(tap: UITapGestureRecognizer){
        if tap.view?.tag == 100 {
            let tabBarController = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
            tabBarController.setSelectIndex(from: 0, to: 1)
        }
    }
    
    //MARK: collectionView点击事件
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let actities = headData!.data!.activities
            let webController = WebViewController(navtigationTitle: actities![indexPath.row].name!, urlStr: actities![indexPath.row].customURL!)
            navigationController?.pushViewController(webController, animated: true)
            
        }else{
            let productVC = ProductDetailViewController(goods: freshHot!.data![indexPath.row])
            navigationController?.pushViewController(productVC, animated: true)
        }
        
    }
    
    //设置cell动画
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section == 0 && (indexPath.row == 0 || indexPath.row == 1) {
            return
        }
        
        if isAnimation {
            startAnimation(view: cell, offsetY: 80, duration: 1.0)
        }
    }
    //设置SectionHeader和SectionFooter动画
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if indexPath.section == 1 && headData != nil && freshHot != nil && isAnimation {
            startAnimation(view: view, offsetY: 60, duration: 0.8)
        }
    }
    
    private func startAnimation(view: UIView,offsetY: CGFloat, duration: TimeInterval){
        
        view.transform = CGAffineTransform(translationX: 0, y: offsetY)
        UIView.animate(withDuration: duration) { 
            view.transform = CGAffineTransform.identity
        }
    }
    
    // MARK: - ScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //滑动的时候隐藏动画
        if (animationLayers != nil) && (animationLayers?.count)! > 0 {
            let transitionLayer = animationLayers![0]
            transitionLayer.isHidden = true
        }
        //用偏移量的改变，设置是否动画
        if scrollView.contentOffset.y <= scrollView.contentSize.height {
            isAnimation = lastContentOffsetY < scrollView.contentOffset.y
            lastContentOffsetY = scrollView.contentOffset.y
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
