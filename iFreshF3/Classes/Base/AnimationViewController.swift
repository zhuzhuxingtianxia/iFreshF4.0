//
//  AnimationViewController.swift
//  iFreshF
//
//  Created by Jion on 16/4/13.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class AnimationViewController: BaseViewController {

    var animationLayers: [CALayer]?
    
    var animationBigLayers: [CALayer]?
    // MARK: 商品添加到购物车动画
    func addProductsAnimation(imageView: UIImageView)  {
        
        if (self.animationLayers == nil)
        {
            self.animationLayers = [CALayer]();
        }
        
        let frame = imageView.convert(imageView.bounds, to: view)
        let transitionLayer = CALayer()
        transitionLayer.frame = frame
        transitionLayer.contents = imageView.layer.contents
        self.view.layer.addSublayer(transitionLayer)
        self.animationLayers?.append(transitionLayer)
        
        let pFrom = transitionLayer.position
        var pTo = CGPoint.zero
        if view.width < ZJScreenWidth {
            pTo = CGPoint(x:view.width - view.width / 3 - view.width / 6, y:self.view.layer.bounds.size.height - 40)
        }else{
            pTo = CGPoint(x:view.width - view.width / 4 - view.width / 8 - 6, y:self.view.layer.bounds.size.height - 40)
        }
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        let path = CGMutablePath()
        path.move(to: CGPoint(x:pFrom.x,y:pFrom.y))
        path.addCurve(to: CGPoint(x:pTo.x,y:pTo.y), control1: CGPoint(x:pFrom.x,y:pFrom.y - 30), control2: CGPoint(x:pTo.x,y:pFrom.y - 30))
        /*
         //绘图代码修改
         var transform = CGAffineTransform.identity
         
        CGPathMoveToPoint(path, &transform, pFrom.x, pFrom.y)
        CGPathAddCurveToPoint(path, nil, pFrom.x, pFrom.y - 30, pTo.x, pFrom.y - 30, pTo.x, pTo.y)
 */
        positionAnimation.path = path
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0.9
        opacityAnimation.fillMode = kCAFillModeForwards
        opacityAnimation.isRemovedOnCompletion = true
        
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        transformAnimation.toValue = NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 1))
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [positionAnimation,transformAnimation,opacityAnimation];
        groupAnimation.duration = 0.8
        groupAnimation.delegate = self
        
        //整个动画是由，位移动画，透明度动画和缩放动画叠加而成的
        transitionLayer.add(groupAnimation, forKey: "cartParabola")
    }
    
     // MARK: - 添加商品到右下角购物车动画
    func addProductsToBigShopCarAnimation(imageView: UIImageView) {
        if animationBigLayers == nil {
            animationBigLayers = [CALayer]()
        }
        
        let frame = imageView.convert(imageView.bounds, to: view)
        let transitionLayer = CALayer()
        transitionLayer.frame = frame
        transitionLayer.contents = imageView.layer.contents
         //这个属性的设置需要和参数imageView的属性设置一致，否则会有抖动
        transitionLayer.contentsGravity = kCAGravityResizeAspect
        self.view.layer.addSublayer(transitionLayer)
        self.animationBigLayers?.append(transitionLayer)
        
        let pFrom = transitionLayer.position
        let pTo = CGPoint(x:view.width - 40, y:view.layer.bounds.size.height - 40)
        
        //初始化位移动画组件
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        //初始化路径
        let path = CGMutablePath()
        
        /*
        //起点
        CGPathMoveToPoint(path, nil, pFrom.x, pFrom.y)
        //路径途经的位置及轨迹方式
        CGPathAddCurveToPoint(path, nil, pFrom.x, pFrom.y - 30, pTo.x, pFrom.y - 30, pTo.x, pTo.y)
 
 */
        path.move(to: CGPoint(x:pFrom.x,y:pFrom.y))
        path.addCurve(to: CGPoint(x:pTo.x,y:pTo.y), control1: CGPoint(x:pFrom.x,y:pFrom.y - 30), control2: CGPoint(x:pTo.x,y:pFrom.y - 30))
        
        //设置动画路径
        positionAnimation.path = path
        
        //初始化透明度动画组件
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0.8
        opacityAnimation.fillMode = kCAFillModeForwards
        opacityAnimation.isRemovedOnCompletion = true
        
        //初始化变换动画
        let transformAnimation = CABasicAnimation(keyPath: "transform")
        transformAnimation.fromValue = NSValue(caTransform3D: CATransform3DIdentity)
        transformAnimation.toValue = NSValue(caTransform3D: CATransform3DScale(CATransform3DIdentity, 0.2, 0.2, 1))
        //加载动画组
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [positionAnimation,transformAnimation,opacityAnimation]
        groupAnimation.duration = 0.8
        groupAnimation.delegate = self
        
        transitionLayer.add(groupAnimation, forKey: "BigShopCarAnimation")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension AnimationViewController:CAAnimationDelegate{
    //MARK: - 动画代理
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        //动画完成移除动画
        if (self.animationLayers != nil) && (self.animationLayers?.count)! > 0 {
            let transitionLayer = animationLayers![0]
            transitionLayer.isHidden = true
            transitionLayer.removeFromSuperlayer()
            animationLayers?.removeFirst()
            view.layer.removeAnimation(forKey: "cartParabola")
        }
        
        if (self.animationBigLayers != nil) && (self.animationBigLayers?.count)! > 0 {
            let transitionLayer = animationBigLayers![0]
            transitionLayer.isHidden = true
            transitionLayer.removeFromSuperlayer()
            animationBigLayers?.removeFirst()
            view.layer.removeAnimation(forKey: "BigShopCarAnimation")
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

