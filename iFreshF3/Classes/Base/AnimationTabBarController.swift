//
//  AnimationTabBarController.swift
//  iFreshF
//
//  Created by Jion on 16/4/12.
//  Copyright © 2016年 Youjuke. All rights reserved.
//

import UIKit

class AnimationTabBarController: UITabBarController {

    var iconsView: [(icon: UIImageView, textLabel: UILabel)] = []
    var iconsImageName:[String] = ["v2_home", "v2_order", "shopCart", "v2_my"]
    var iconsSelectedImageName:[String] = ["v2_home_r", "v2_order_r", "shopCart_r", "v2_my_r"]
    var shopCarIcon: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //加入版本检测后下面的textLabel的字体不见了，为什么？？？
//        let  window = (UIApplication.sharedApplication().delegate as! AppDelegate).window
//        updateVersionWithWindow(window!, appId: "1039262702")

        // Do any additional setup after loading the view.
        
        //添加搜索视图消失时的通知，目的是重新添加小红点
        NotificationCenter.default.addObserver(self, selector: #selector(AnimationTabBarController.searchViewControllerDeinit), name: NSNotification.Name(rawValue: "LFBSearchViewControllerDeinit"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func searchViewControllerDeinit(){
        if shopCarIcon != nil {
            let redDotView = ShopCarRedDotView.sharedRedDotView
            redDotView.frame = CGRect(x:21 + 1, y:-3, width:15, height:15)
            shopCarIcon?.addSubview(redDotView)
        }

    }
    
    func createViewContainers() -> [String: UIView]{
        var containersDict = [String: UIView]()
        guard let customItems = tabBar.items as? [RAMAnimatedTabBarItem] else{
            
            return containersDict
        }
        for index in 0..<customItems.count {
            let viewContainer = createViewContainer(index: index)
            containersDict["container\(index)"] = viewContainer
        }
        
        return containersDict
    }
    
   private func createViewContainer(index: Int) -> UIView {
        let viewWidth: CGFloat = ZJScreenWidth / CGFloat(tabBar.items!.count)
        let viewHeight: CGFloat = tabBar.bounds.size.height
        
        
    let viewContainer = UIView(frame: CGRect(x:viewWidth * CGFloat(index),y:0,width:viewWidth,height:viewHeight))
        viewContainer.backgroundColor = UIColor.clear
        viewContainer.isUserInteractionEnabled = true
        tabBar.addSubview(viewContainer)
        viewContainer.tag = index
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AnimationTabBarController.tabBarClick(objc:)))
        viewContainer.addGestureRecognizer(tap)

        return viewContainer
    }
    
    func createCustomIcons(containers : [String: UIView]){
        if let items = tabBar.items {
            for (index, item) in items.enumerated() {
                assert(item.image != nil, "add image icon in UITabBarItem")
                
                guard let container = containers["container\(index)"] else{
                
                    print("No container given")
                    continue
                }
                container.tag = index
                let imageW:CGFloat = 21
                let imageX:CGFloat = (ZJScreenWidth / CGFloat(items.count) - imageW) * 0.5
                let imageY:CGFloat = 8
                let imageH:CGFloat = 21
                let icon = UIImageView(frame: CGRect(x: imageX, y: imageY, width: imageW, height: imageH))
                icon.image = item.image
                icon.tintColor = UIColor.clear
                container.addSubview(icon)
                // text
                let textLabel = UILabel()
                textLabel.frame = CGRect(x:0, y:32, width:ZJScreenWidth / CGFloat(items.count), height:49 - 32)
                textLabel.text = item.title
                textLabel.backgroundColor = UIColor.clear
                textLabel.font = UIFont.systemFont(ofSize: 10)
                textLabel.textAlignment = NSTextAlignment.center
                textLabel.textColor = UIColor.gray
                
                container.addSubview(textLabel)
                //设置text显示宽度
                if let tabBarItem = tabBar.items {
                    let textLabelWidth = tabBar.frame.size.width / CGFloat(tabBarItem.count)
                    textLabel.bounds.size.width = textLabelWidth
                }
                
                if 2 == index{
                   //单独处理购物车
                    let redDotView = ShopCarRedDotView.sharedRedDotView
                    redDotView.frame = CGRect(x:imageH + 1, y:-3, width:15, height:15)
                    icon.addSubview(redDotView)
                    shopCarIcon = icon
                }
                
                let iconsAndLabels = (icon:icon, textLabel:textLabel)
                iconsView.append(iconsAndLabels)

                
                item.image = nil
                item.title = ""
                
                if index == 0 {
                    selectedIndex = 0
                    selectItem(Index: 0)
                }
            }
        }
        
    }
   
   private func selectItem(Index: Int){
       let items = tabBar.items as! [RAMAnimatedTabBarItem]
       let selectIcon = iconsView[Index].icon
       selectIcon.image = UIImage(named: iconsSelectedImageName[Index])!
      items[Index].selectedState(icon: selectIcon, textLabel: iconsView[Index].textLabel)
    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        setSelectIndex(from: selectedIndex, to: item.tag)
    }
    func setSelectIndex(from: Int,to: Int){
        //在点击购物车的时候单独处理
        if to == 2 {
            let vc = childViewControllers[selectedIndex]
            let shopCar = ShopCartViewController()
            let nav = BaseNavigationController(rootViewController: shopCar)
            vc.present(nav, animated: true, completion: nil)
            
            return
        }
        
        selectedIndex = to
        let items = tabBar.items as! [RAMAnimatedTabBarItem]
        let fromIV = iconsView[from].icon
        fromIV.image = UIImage(named: iconsImageName[from])
        
        items[from].deselectAnimation(icon: fromIV, textLabel: iconsView[from
            ].textLabel)
        let toIV = iconsView[to].icon
        toIV.image = UIImage(named: iconsSelectedImageName[to])
        //设置动画
        items[to].playAnimation(icon: toIV, textLabel: iconsView[to].textLabel)
        
    }
    
    @objc func tabBarClick(objc: AnyObject?) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

/************************/
/************************/

//定义一个协议
protocol RAMItemAnimationProtocol {
    
    func playAnimation(icon : UIImageView, textLabel : UILabel)
    func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor)
    func selectedState(icon : UIImageView, textLabel : UILabel)
}
//该类实现了上面的协议方法
class RAMItemAnimation: NSObject,RAMItemAnimationProtocol{
    var duration : CGFloat = 0.6
    var textSelectedColor: UIColor = UIColor.gray
    var iconSelectedColor: UIColor?
    
    func playAnimation(icon: UIImageView, textLabel: UILabel) {
        
    }
    func deselectAnimation(icon: UIImageView, textLabel: UILabel, defaultTextColor: UIColor) {
        
    }
    func selectedState(icon: UIImageView, textLabel: UILabel) {
        
    }
}

class RAMAnimatedTabBarItem: UITabBarItem{
    var animation:RAMItemAnimation?
    var textColor = UIColor.gray
    
    func playAnimation(icon: UIImageView,textLabel: UILabel){
        guard let animation = animation else {
            print("add animation in UITabBarItem")
            return
        }
        animation.playAnimation(icon: icon, textLabel: textLabel)
        
    }
    
    func deselectAnimation(icon: UIImageView,textLabel: UILabel){
        animation?.deselectAnimation(icon: icon, textLabel: textLabel, defaultTextColor: textColor)
    }
    
    func selectedState(icon: UIImageView, textLabel: UILabel) {
        animation?.selectedState(icon: icon, textLabel: textLabel)
    }
    
}

class RAMBounceAnimation : RAMItemAnimation{
    
    override func playAnimation(icon: UIImageView, textLabel: UILabel) {
        playBounceAnimation(icon: icon)
        textLabel.textColor = textSelectedColor
    }
    override func deselectAnimation(icon : UIImageView, textLabel : UILabel, defaultTextColor : UIColor) {
        textLabel.textColor = defaultTextColor
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysOriginal)
            icon.image = renderImage
            icon.tintColor = defaultTextColor
            
        }
    }
    override func selectedState(icon : UIImageView, textLabel : UILabel) {
        textLabel.textColor = textSelectedColor
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysOriginal)
            icon.image = renderImage
            icon.tintColor = textSelectedColor
        }
    }

    func playBounceAnimation(icon : UIImageView){
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        icon.layer.add(bounceAnimation, forKey: "bounceAnimation")
        
        if let iconImage = icon.image{
            let renderImage = iconImage.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
            icon.image = renderImage
            icon.tintColor = iconSelectedColor
        }
    }
}
