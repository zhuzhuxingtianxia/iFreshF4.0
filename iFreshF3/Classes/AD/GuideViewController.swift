//
//  GuideViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/11.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class GuideViewController: BaseViewController {

     var collectionView: UICollectionView?
     var imageNames = ["guide_40_1", "guide_40_2", "guide_40_3", "guide_40_4"]
     let cellIdentifier = "GuideCell"
     var isHiddenNextButton = true
     var pageController = UIPageControl(frame: CGRect(x:0, y:ZJScreenHeight - 50, width:ZJScreenWidth, height:20))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
        buildCollectionView()
        buildPageController()
        
        // Do any additional setup after loading the view.
    }

    // MARK: - Build UI
    private func buildCollectionView(){
        let layout  = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = ZJScreenBounds.size
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView = UICollectionView(frame: ZJScreenBounds, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.isPagingEnabled = true
        collectionView?.bounces = false
        collectionView?.register(GuideCell.self, forCellWithReuseIdentifier: cellIdentifier)
        view.addSubview(collectionView!)
        
        
    }
    
    private func buildPageController(){
        pageController.numberOfPages = imageNames.count
        pageController.currentPage = 0
        view.addSubview(pageController)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//MARK:--UICollectionViewDelegate
extension GuideViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! GuideCell
        cell.newImage = UIImage(named: imageNames[indexPath.row])
        if indexPath.row != imageNames.count-1 {
            cell.setNextButtonHidden(hidden: true)
        }
        
        return cell
    }
    
    //滑动使用scrollView的代理
    
    //滚动视图停止后的回调
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == ZJScreenWidth * CGFloat(imageNames.count-1) {
            let cell = collectionView!.cellForItem(at: IndexPath(item: imageNames.count - 1, section: 0)) as! GuideCell
            cell.setNextButtonHidden(hidden: false)
            isHiddenNextButton = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != ZJScreenWidth * CGFloat(imageNames.count-1) && !isHiddenNextButton && scrollView.contentOffset.x > ZJScreenWidth * CGFloat(imageNames.count - 2) {
            
            let cell = collectionView!.cellForItem(at: IndexPath(item: imageNames.count - 1, section: 0)) as! GuideCell
            cell.setNextButtonHidden(hidden: true)
            isHiddenNextButton = true
        }
        
         pageController.currentPage = Int(scrollView.contentOffset.x / ZJScreenWidth + 0.5)
    }
    
}









//end
