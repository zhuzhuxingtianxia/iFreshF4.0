//
//  PageScrollView.swift
//  iFreshF
//
//  Created by Jion on 16/5/4.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit
//设置PageControl的位置
enum PageControlLoction {
    //默认为不显示pageControl
    case Defaults
    case Center
    case Left
    case Right
}

class PageScrollView: UIView {

     let imageViewMaxCount = 3
     var imageScrollView: UIScrollView!
     var pageControl: UIPageControl!
     var timer: Timer?
     var placeholderImage: UIImage?
     var imageClick:((_ index: Int) -> ())?
    //是否自动循环
    var  isCycle:Bool = false
    var pageControlLoction:PageControlLoction = .Center
    
    var headData: HeadResources? {
        didSet {
            if timer != nil {
                timer!.invalidate()
                timer = nil
            }
            
            if (headData?.data?.focus?.count)! >= 0 {
                pageControl.numberOfPages = (headData?.data?.focus?.count)!
                pageControl.currentPage = 0
                
                updatePageScrollView()
                startTimer()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        buildImageScrollView()
        buildPageControl()
    }
    
    convenience init(frame: CGRect,placeholder: UIImage, focusImageViewClick:@escaping ((_ index: Int) -> Void)) {
        self.init(frame:frame)
        placeholderImage = placeholder
        imageClick = focusImageViewClick
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: BuildUI
    private func buildImageScrollView() {
        imageScrollView = UIScrollView()
        imageScrollView.bounces = false
        imageScrollView.showsHorizontalScrollIndicator = false
        imageScrollView.showsVerticalScrollIndicator = false
        imageScrollView.isPagingEnabled = true
        imageScrollView.delegate = self
        addSubview(imageScrollView)
        
        for _ in 0..<3 {
            let imageView = UIImageView()
            let tap = UITapGestureRecognizer(target: self, action: #selector(PageScrollView.imageViewClick(tap:)))
            imageView.addGestureRecognizer(tap)
            imageScrollView.addSubview(imageView)
        }
    }
    
    private func buildPageControl() {
        pageControl = UIPageControl()
        pageControl.hidesForSinglePage = true
        pageControl.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "v2_home_cycle_dot_normal")!)
        pageControl.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "v2_home_cycle_dot_selected")!)
        addSubview(pageControl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageScrollView.frame = bounds
        imageScrollView.contentSize = CGSize(width:CGFloat(imageViewMaxCount) * width, height:0)
        for i in 0...imageViewMaxCount - 1 {
            let imageView = imageScrollView.subviews[i] as! UIImageView
            imageView.isUserInteractionEnabled = true
            imageView.frame = CGRect(x:imageScrollView.width * CGFloat(i), y:0, width:imageScrollView.width, height:imageScrollView.height)
        }
        
        let pageW: CGFloat = 80
        let pageH: CGFloat = 20
        var pageX: CGFloat = 0
        let pageY: CGFloat = imageScrollView.height - pageH
        
        var rect: CGRect = CGRect.zero
        
        switch pageControlLoction {
        case .Left:
            pageX = imageScrollView.width - pageW
            rect = CGRect(x:pageX, y:pageY, width:pageW, height:pageH)
        case .Center:
            pageX = imageScrollView.center.x - pageW * 0.5
            rect = CGRect(x:pageX, y:pageY, width:pageW, height:pageH)
        case .Right:
            pageX = 10
            rect = CGRect(x:pageX, y:pageY, width:pageW, height:pageH)
        default:break
            
        }
        
        pageControl.frame = rect
        
        updatePageScrollView()
    }

    
     //MARK: 更新内容
    func updatePageScrollView() {
        for i in 0 ..< imageScrollView.subviews.count{
            let imageView = imageScrollView.subviews[i] as! UIImageView
            var index = pageControl.currentPage
            
            if i == 0 {
                index -= 1
            }else if i == 2{
                index += 1
            }
            
            if index < 0 {
                index = self.pageControl.numberOfPages - 1
            }else if index >= self.pageControl.numberOfPages {
                index = 0
            }
            
            imageView.tag = index
            if (headData?.data?.focus?.count)! > 0 {
                imageView.sd_setImage(with: URL(string:headData!.data!.focus![index].img!), placeholderImage: placeholderImage)
                
            }
            
        }
        
        imageScrollView.contentOffset = CGPoint(x:imageScrollView.width, y:0)
    }
    
    //MARK: Timer
     func startTimer() {
        if isCycle {
            timer = Timer(timeInterval: 3.0, target: self, selector: #selector(getter: PageScrollView.next), userInfo: nil, repeats: true)
            RunLoop.main.add(timer!, forMode: RunLoopMode.commonModes)
        }
       
    }
     func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func next() {
        imageScrollView.setContentOffset(CGPoint(x:2.0 * imageScrollView.frame.size.width, y:0), animated: true)
    }
    
    // MARK: Action
    @objc func imageViewClick(tap:UITapGestureRecognizer) {
        if imageClick != nil {
            imageClick!(tap.view!.tag)
        }
    }

}
// MARK:- UIScrollViewDelegate
extension PageScrollView: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var page:Int = 0
        var minDistance: CGFloat = CGFloat(MAXFLOAT)
        
        for i in 0..<imageScrollView.subviews.count {
            let imageView = imageScrollView.subviews[i] as! UIImageView
            let distance:CGFloat = abs(imageView.x - scrollView.contentOffset.x)
            
            if distance < minDistance {
                minDistance = distance
                page = imageView.tag
            }
        }
        
        pageControl.currentPage = page
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        startTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageScrollView()
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        updatePageScrollView()
    }
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 override func drawRect(rect: CGRect) {
 // Drawing code
 }
 */
