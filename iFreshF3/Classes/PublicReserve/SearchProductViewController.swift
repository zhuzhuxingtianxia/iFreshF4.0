//
//  SearchProductViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/15.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class SearchProductViewController: AnimationViewController {
    
    private let contentScrollView = UIScrollView(frame: ZJScreenBounds)
     let searchBar = UISearchBar()
    private var hotSearchView: SearchView?
    private var historySearchView: SearchView?
     private let cleanHistoryButton: UIButton = UIButton()
     var searchCollectionView: LFBCollectionView?
    private var collectionHeadView: NotSearchProductsView?
     var goodses: [Goods]?
     var yellowShopCar: YellowShopCarView?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buildContentScrollView()
        buildSearchBar()
        loadHotSearchButtonData()
        
        buildCleanHistorySearchButton()
        loadHistorySearchButtonData()
        
        buildsearchCollectionView()
        buildYellowShopCar()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barTintColor = LFBNavigationBarWhiteBackgroundColor
        
        if searchCollectionView != nil && (goodses != nil) {
            searchCollectionView!.reloadData()
        }
    }
    deinit {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "LFBSearchViewControllerDeinit"), object: nil)
    }
    

    // MARK: - Build UI
    private func buildContentScrollView() {
        contentScrollView.backgroundColor = view.backgroundColor
        contentScrollView.alwaysBounceVertical = true
        contentScrollView.delegate = self
        view.addSubview(contentScrollView)
    }
    private func buildSearchBar() {
        (navigationController as! BaseNavigationController).backBtn.frame = CGRect(x:0, y:0, width:10, height:40)
        
        let tmpView = UIView(frame: CGRect(x:0,y:0,width:ZJScreenWidth * 0.8,height:30))
        tmpView.backgroundColor = UIColor.white
        tmpView.layer.masksToBounds = true
        tmpView.layer.cornerRadius = 6.0
        tmpView.layer.borderColor = UIColor.colorWithRGBA(r:100, g: 100, b: 100, a: 1).cgColor
        tmpView.layer.borderWidth = 0.2
        let image = UIImage.createImageFromView(view: tmpView)
        
        searchBar.frame = CGRect(x:0, y:0, width:ZJScreenWidth * 0.9, height:30)
        searchBar.placeholder = "请输入商品名称"
        searchBar.barTintColor = UIColor.white
        searchBar.keyboardType = UIKeyboardType.default
        searchBar.setSearchFieldBackgroundImage(image, for: UIControlState.normal)
        searchBar.delegate = self
      navigationItem.titleView = searchBar
      
    }
    private func buildsearchCollectionView() {
        let layout = UICollectionViewFlowLayout()
        //item之间的间隔
        layout.minimumInteritemSpacing = 5
        //行之间的间隔
        layout.minimumLineSpacing = 8
        //到边缘的间隔
        layout.sectionInset = UIEdgeInsets(top: 0, left: HomeCollectionViewCellMargin, bottom: 0, right: HomeCollectionViewCellMargin)
        layout.headerReferenceSize = CGSize(width:0,height: HomeCollectionViewCellMargin)
        
        searchCollectionView = LFBCollectionView(frame: CGRect(x:0, y:0, width:ZJScreenWidth, height:ZJScreenHeight - 64), collectionViewLayout: layout)
        searchCollectionView!.delegate = self
        searchCollectionView!.dataSource = self
        searchCollectionView!.backgroundColor = LFBGlobalBackgroundColor
        searchCollectionView!.register(HomeCell.self, forCellWithReuseIdentifier: "Cell")
        searchCollectionView?.register(HomeCollectionFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView")
//        weak var tmpSelf = self
        collectionHeadView = NotSearchProductsView(frame: CGRect(x:0, y:-80, width:ZJScreenWidth, height:80), tapAction: {
//             tmpSelf!.searchBar.resignFirstResponder()
        })
        searchCollectionView?.addSubview(collectionHeadView!)
        searchCollectionView?.contentInset = UIEdgeInsets(top: 80, left: 0, bottom: 30, right: 0)
        searchCollectionView?.isHidden = true
        view.addSubview(searchCollectionView!)
        
    }
    
    private func buildYellowShopCar() {
        
        weak var tmpSelf = self
        
        yellowShopCar = YellowShopCarView(frame: CGRect(x:ZJScreenWidth - 70, y:ZJScreenHeight - 70 - Navigation, width:61, height:61), shopViewClick: { () -> () in
            let shopCarVC = ShopCartViewController()
            let nav = BaseNavigationController(rootViewController: shopCarVC)
            tmpSelf!.present(nav, animated: true, completion: nil)
        })
        yellowShopCar?.isHidden = true
        view.addSubview(yellowShopCar!)
    }

    
     // MARK: - Build Data
    private func loadHotSearchButtonData() {
        var array: [String]?
        var historySearch = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        
        if historySearch == nil {
            historySearch = [String]()
            UserDefaults.standard.set(historySearch, forKey: LFBSearchViewControllerHistorySearchArray)
        }
        
        let pathStr = Bundle.main.path(forResource: "SearchProduct", ofType: nil)
        let data = NSData(contentsOfFile: pathStr!)
        if data != nil {
            let dict: NSDictionary = (try! JSONSerialization.jsonObject(with: data! as Data, options: JSONSerialization.ReadingOptions.allowFragments)) as! NSDictionary
            array = (dict.object(forKey: "data")! as! NSDictionary).object(forKey: "hotquery") as? [String]
            weak var tmpSelf = self
            if (array?.count)! > 0 {
                hotSearchView = SearchView(frame: CGRect(x:10, y:20, width: ZJScreenWidth - 20, height:100), searchTitleText: "热门搜索", searchButtonTitleTexts: array!, searchButtonClickCallback: { (sender) in
                    let str = sender.title(for: UIControlState.normal)
                    //保存
                    tmpSelf?.writeHistorySearchToUserDefault(str: str!)
                    //显示在searchBar.text上
                    tmpSelf!.searchBar.text = str
                    //加载搜索的关键词
                    tmpSelf!.loadProductsWithKeyword(keyWord: str!)
                    
                })
                hotSearchView!.frame.size.height = hotSearchView!.searchHeight
                
                contentScrollView.addSubview(hotSearchView!)
            }
        }
    }
    
    private func loadHistorySearchButtonData() {
        if historySearchView != nil {
            historySearchView?.removeFromSuperview()
            historySearchView = nil
        }
        
        let array = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        weak var tmpSelf = self
        if (array?.count)! > 0 {
            historySearchView = SearchView(frame: CGRect(x:10, y:hotSearchView!.frame.maxY + 20, width:ZJScreenWidth - 20, height:0), searchTitleText: "历史记录", searchButtonTitleTexts: array!, searchButtonClickCallback: { (sender) in
                 let str = sender.title(for: UIControlState.normal)
                tmpSelf?.searchBar.text = str
                tmpSelf?.loadProductsWithKeyword(keyWord: str!)
            })
            historySearchView!.frame.size.height = historySearchView!.searchHeight
            contentScrollView.addSubview(historySearchView!)
            //显示清空记录按钮
            updateCleanHistoryButton(hidden: false)
        }
    }
    private func buildCleanHistorySearchButton() {
        cleanHistoryButton.setTitle("清 空 历 史", for: UIControlState.normal)
        cleanHistoryButton.setTitleColor(UIColor.colorWithRGB(r: 163, g: 163, b: 163), for: UIControlState.normal)
        cleanHistoryButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        cleanHistoryButton.backgroundColor = view.backgroundColor
        cleanHistoryButton.layer.cornerRadius = 5
        cleanHistoryButton.layer.borderColor = UIColor.colorWithRGB(r: 200, g: 200, b: 200).cgColor
        cleanHistoryButton.layer.borderWidth = 0.5
        cleanHistoryButton.isHidden = true
        cleanHistoryButton.addTarget(self, action: #selector(SearchProductViewController.cleanSearchHistorySearch), for: UIControlEvents.touchUpInside)
        contentScrollView.addSubview(cleanHistoryButton)
    }

    private func updateCleanHistoryButton(hidden: Bool) {
        if historySearchView != nil {
            cleanHistoryButton.frame = CGRect(x:0.1 * ZJScreenWidth, y:historySearchView!.frame.maxY + 20, width:ZJScreenWidth * 0.8, height:40)
        }
        cleanHistoryButton.isHidden = hidden
    }
    // MARK: - Action
    @objc func cleanSearchHistorySearch() {
        var historySearch = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        
        historySearch?.removeAll()
        UserDefaults.standard.set(historySearch, forKey: LFBSearchViewControllerHistorySearchArray)
        loadHistorySearchButtonData()
        updateCleanHistoryButton(hidden: true)
    }
    
     // MARK: -  Method
     func writeHistorySearchToUserDefault(str: String) {
        var historySearch = UserDefaults.standard.object(forKey: LFBSearchViewControllerHistorySearchArray) as? [String]
        
        for text in historySearch! {
            if text == str {
                return
            }
        }
        
        historySearch!.append(str)
        UserDefaults.standard.set(historySearch, forKey: LFBSearchViewControllerHistorySearchArray)
        loadHistorySearchButtonData()
    }
    
    
    func loadProductsWithKeyword(keyWord: String?) {
        if keyWord == nil || keyWord?.characters.count == 0 {
            return
        }
        
        ProgressHUDManager.setBackgroundColor(color: UIColor.white)
        ProgressHUDManager.showWithStatus(status: "正在全力加载")
        //GCD延时
        weak var tmpSef = self
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            //swift3.0写法
            SearchProducts.loadSearchData(completion: { (data, error) in
                ProgressHUDManager.dismiss()
                if (data?.data?.count)! > 0 {
                    tmpSef?.goodses = data!.data!
                    tmpSef?.searchCollectionView?.isHidden = false
                    tmpSef?.yellowShopCar?.isHidden = false
                    tmpSef?.searchCollectionView?.reloadData()
                    tmpSef?.collectionHeadView?.setSearchProductLabelText(text: keyWord!)
                    tmpSef?.searchCollectionView?.setContentOffset(CGPoint(x:0,y: -80), animated: false)
                }
            })

        })
        /*
         //swift2.2写法
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0 * Double(NSEC_PER_SEC)))
        dispatch_after(time, dispatch_get_main_queue()) { 
            SearchProducts.loadSearchData({ (data, error) in
                ProgressHUDManager.dismiss()
                if data?.data?.count > 0 {
                   tmpSef?.goodses = data!.data!
                    tmpSef?.searchCollectionView?.hidden = false
                    tmpSef?.yellowShopCar?.hidden = false
                    tmpSef?.searchCollectionView?.reloadData()
                    tmpSef?.collectionHeadView?.setSearchProductLabelText(keyWord!)
                    tmpSef?.searchCollectionView?.setContentOffset(CGPointMake(0, -80), animated: false)
                }
            })
        }
   */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchBar.endEditing(true)
    }

}

extension SearchProductViewController: UIScrollViewDelegate,UISearchBarDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    //点击搜索按钮
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if (searchBar.text?.characters.count)! > 0 {
            //保存输入内容
            writeHistorySearchToUserDefault(str: searchBar.text!)
            //加载搜索关键词
            loadProductsWithKeyword(keyWord: searchBar.text!)
        }
    }
    
    //搜索内容发生变化时调用
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count == 0 {
            searchCollectionView?.isHidden = true
            yellowShopCar?.isHidden = true
        }
    }
}

extension SearchProductViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goodses?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! HomeCell
        cell.goods = goodses![indexPath.item]
        weak var tmpSelf = self
        cell.addButtonClick = {(imgaeView) in
            tmpSelf?.addProductsToBigShopCarAnimation(imageView: imgaeView)
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = CGSize(width:(ZJScreenWidth - 3 * HomeCollectionViewCellMargin) * 0.5, height:250)
        
        return itemSize
    }
    
    //设置区头尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        //区的header设为0
        return CGSize.zero
    }
    
    //设置区尾尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if goodses == nil || (goodses?.count)! <= 0 {
            return CGSize.zero
        }
        
        return CGSize(width:ZJScreenWidth, height:30)
    }
    
    //设置区头区尾View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView", for: indexPath as IndexPath) as! HomeCollectionFooterView
            
            footerView.setFooterTitle(text: "无更多商品", textColor: UIColor.colorWithRGB(r: 50, g: 50, b: 50))
            
            return footerView
            
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footerView", for: indexPath as IndexPath)
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailVC = ProductDetailViewController(goods: goodses![indexPath.row])
        navigationController?.pushViewController(productDetailVC, animated: true)
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
